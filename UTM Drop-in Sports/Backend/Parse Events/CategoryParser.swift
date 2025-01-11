//
//  File.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import SwiftUI

class CategoryParser: ObservableObject {
    private var allEvents: [Event] = []
    
    @Published var featuredEvents: [Event] = []
    @Published var announcements: [Announcement] = []
    @Published var categories: [Category] = []
    
    @Published var events: [Event] = []
    @Published var savedEvents: [Event] = []
    @Published var savedOngoingEvents: [Event] = []
    @Published var groupedEvents: AllEvents = AllEvents(events: [], maxEvents: nil, columnCount: 1)
    @Published var columnCount: Int = 1
    private var updateDisplayEventsID: UUID = UUID()
    
    @Published var isUpdating: Bool = true
    @Published var onlyWomens: Bool = false
    @Published var onlyLGBT: Bool = false
    @Published var onlySaved: Bool = false
    
    @Published var isEventsExpandedToMax: Bool = false
    
    @Published var medalsCollected: [Medal] = []
    
    var searchField: String = ""
    var lastUpdated: Date? = nil
    private var isUpdatingPrivate: Bool = false
    
    private var timer: DispatchSourceTimer?
    
    init() {
        self.tryRefreshContent()
    }
    
    init() async {
        await self.tryRefreshContentAsync()
    }
    
    func tryRefreshContent() {
        if let lastUpdated = self.lastUpdated {
            if areDatesWithinTenMinutes(Date(), lastUpdated) {
                return
            }
        }
        if self.isUpdatingPrivate {
            return
        }
        self.isUpdatingPrivate = true
        Task {
            await self.eventFileFetcher()
            let eventJSON: EventJSON? = loadEventJSON()
            if let eventJSON = eventJSON {
                await MainActor.run {
                    self.featuredEvents = self.parseFeatured(eventJSON.featured)
                    self.announcements = eventJSON.announcements
                    if self.categories.isEmpty {
                        withAnimation {
                            self.categories = eventJSON.categories
                        }
                    }
                    self.allEvents = eventJSON.events
                    self.lastUpdated = Date()
                    self.updateSavedEvents()
                    self.updateDisplayEvents(maxEvents: 50)
                    self.updateMedalsCollected()
                    self.isUpdatingPrivate = false
                    self.startTimerLoop()
                }
            }
        }
    }
    
    func tryRefreshContentAsync() async {
        if let lastUpdated = self.lastUpdated {
            if areDatesWithinTenMinutes(Date(), lastUpdated) {
                return
            }
        }
        if self.isUpdatingPrivate {
            return
        }
        self.isUpdatingPrivate = true
        await self.eventFileFetcher()
        let eventJSON: EventJSON? = loadEventJSON()
        if let eventJSON = eventJSON {
            self.categories = eventJSON.categories
            self.allEvents = eventJSON.events
            print(self.allEvents.count)
            self.lastUpdated = Date()
            self.updateSavedEvents()
            await self.updateDisplayEventsAsync()
            self.updateMedalsCollected()
            self.isUpdatingPrivate = false
        }
    }
    
    func startTimerLoop() {
            // Cancel any existing timer
            timer?.cancel()

            // Create a new timer
            timer = DispatchSource.makeTimerSource()
            timer?.schedule(deadline: .now(), repeating: 5.0)

            timer?.setEventHandler { [weak self] in
                self?.tryRefreshContent()
            }

            // Start the timer
            timer?.resume()
        }

        func stopTimerLoop() {
            // Cancel the timer when stopping
            timer?.cancel()
            timer = nil
        }
    
    func areDatesWithinTenMinutes(_ date1: Date, _ date2: Date) -> Bool {
        let timeInterval = abs(date1.timeIntervalSince(date2))
        return timeInterval <= 60 // 60 seconds = 1 minute
    }

    func eventFileFetcher() async {
        let userDefaults = UserDefaults.standard
        let versionURL = URL(string: "https://raw.githubusercontent.com/OatsCG/UTM-Drop-Ins-Schedule/main/version.txt")!
        let eventsURL = URL(string: "https://raw.githubusercontent.com/OatsCG/UTM-Drop-Ins-Schedule/main/events.json")!
        
        // Fetch version.txt content from the remote server
        do {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 3 // 3 seconds timeout
            let session = URLSession(configuration: config)
            
            let data: (Data, URLResponse)? = try? await session.data(from: versionURL)
            let versionData: Data? = data?.0
            
            let storedVersion = userDefaults.string(forKey: "version.txt")
            var fetchedVersion: String
            
            if let versionData = versionData {
                print("Fetched Version: \(versionData)")
                if let decodedVersion = String(data: versionData, encoding: .utf8) {
                    fetchedVersion = decodedVersion
                } else {
                    return
                }
            } else {
                if let storedVersion = storedVersion {
                    fetchedVersion = storedVersion
                } else {
                    return
                }
            }
            
            // Compare with stored version
            if storedVersion == fetchedVersion {
                // Versions match, do nothing and return
                return
            }
            // Fetch events.json content from the remote server
            let (eventsData, _) = try await URLSession.shared.data(from: eventsURL)
            
            // Save events.json locally
            let fileManager = FileManager.default
            if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let eventsFileURL = documentsDirectory.appendingPathComponent("events.json")
                do {
                    try eventsData.write(to: eventsFileURL)
                    
                    // Update UserDefaults with the new version
                    userDefaults.setValue(fetchedVersion, forKey: "version.txt")
                } catch {
                    print("Error saving events.json: \(error)")
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func parseFeatured(_ featured: [Event]) -> [Event] {
        return featured.filter { $0.relativeTimeDate.isEventOver == false }
    }

    func updateDisplayEventsAsync() async {
        print("UPDATING DISPLAY EVENTS")
        let udeID: UUID = UUID()
        self.updateDisplayEventsID = udeID
        let notOverEvents: [Event] = self.allEvents.filter { $0.relativeTimeDate.isEventOver == false }
        let savedRespectedEvents: [Event] = self.onlySaved ? self.savedEvents : notOverEvents
        let lgbtRespectedEvents: [Event] = savedRespectedEvents.filter { !self.onlyLGBT || $0.lgbt }
        let womensRespectedEvents: [Event] = lgbtRespectedEvents.filter { !self.onlyWomens || $0.womens }
        var searchedEvents: [Event] = []
        for event in womensRespectedEvents {
            if event.title.lowercased().contains(self.searchField.lowercased()) ||
                event.description.lowercased().contains(self.searchField.lowercased()) ||
                event.venue.lowercased().contains(self.searchField.lowercased()) ||
                self.searchField == "" {
                
                searchedEvents.append(event)
            }
        }
        
        var selectedCategories: [Category] = []
        for category in self.categories {
            if category.selected {
                selectedCategories.append(category)
            }
        }
        let selfevents: [Event]
        if selectedCategories.count == 0 {
            selfevents = searchedEvents
        } else {
            var allowedEvents: [Event] = []
            for event in searchedEvents {
                if selectedCategories.contains(where: { $0.title == event.sortCategory }) {
                    allowedEvents.append(event)
                }
            }
            selfevents = allowedEvents
        }
        if self.updateDisplayEventsID == udeID {
            withAnimation(.easeOut) {
                self.events = selfevents
                self.isUpdating = false
                self.groupedEvents = AllEvents(events: self.events, maxEvents: nil, columnCount: self.columnCount)
                self.isEventsExpandedToMax = true
            }
            print("done!")
        }
    }
    
    func updateDisplayEvents(maxEvents: Int?) {
        print("UPDATING DISPLAY EVENTS")
        let udeID: UUID = UUID()
        self.updateDisplayEventsID = udeID
        Task.detached {
            let notOverEvents: [Event] = self.allEvents.filter { $0.relativeTimeDate.isEventOver == false }
            let savedRespectedEvents: [Event] = self.onlySaved ? self.savedEvents : notOverEvents
            let lgbtRespectedEvents: [Event] = savedRespectedEvents.filter { !self.onlyLGBT || $0.lgbt }
            let womensRespectedEvents: [Event] = lgbtRespectedEvents.filter { !self.onlyWomens || $0.womens }
            var searchedEvents: [Event] = []
            for event in womensRespectedEvents {
                if event.title.lowercased().contains(self.searchField.lowercased()) ||
                    event.description.lowercased().contains(self.searchField.lowercased()) ||
                    event.venue.lowercased().contains(self.searchField.lowercased()) ||
                    self.searchField == "" {
                    
                    searchedEvents.append(event)
                }
            }
            
            
            var selectedCategories: [Category] = []
            for category in self.categories {
                if category.selected {
                    selectedCategories.append(category)
                }
            }
            let selfevents: [Event]
            if selectedCategories.count == 0 {
                selfevents = searchedEvents
            } else {
                var allowedEvents: [Event] = []
                for event in searchedEvents {
                    if selectedCategories.contains(where: { $0.title == event.sortCategory }) {
                        allowedEvents.append(event)
                    }
                }
                selfevents = allowedEvents
            }
            await MainActor.run {
                if self.updateDisplayEventsID == udeID {
                    withAnimation(.easeOut) {
                        self.events = selfevents
                        self.isUpdating = false
                        if let maxEvents = maxEvents {
                            self.groupedEvents = AllEvents(events: self.events, maxEvents: maxEvents, columnCount: self.columnCount)
                            self.isEventsExpandedToMax = false
                        } else {
                            self.groupedEvents = AllEvents(events: self.events, maxEvents: nil, columnCount: self.columnCount)
                            self.isEventsExpandedToMax = true
                        }
                    }
                    print("done!")
                }
            }
        }
    }
    
    func saveEvent(event: Event) {
        // save the event. when app is launched after saved time, show Award sheet.
        //UserDefaults.
        // get userDefaults SavedEventIDs
        let savedEventIDs: String = UserDefaults.standard.string(forKey: "SavedEventIDs") ?? ""
        // split via <SEP> -> [String] of event ids
        var splitSavedEventIDs: [String] = savedEventIDs.components(separatedBy: "<SEP>")
        // remove event.id
        splitSavedEventIDs.removeAll(where: { $0 == String(event.id) })
        // append event.id
        splitSavedEventIDs.append(String(event.id))
        // combine with <SEP>
        let combinedSavedEventIDs: String = splitSavedEventIDs.joined(separator: "<SEP>")
        // save to userDefaults SavedEventIDs
        UserDefaults.standard.set(combinedSavedEventIDs, forKey: "SavedEventIDs")
        
        self.updateSavedEvents()
    }
    
    func unsaveEvent(event: Event) {
        // save the event. when app is launched after saved time, show Award sheet.
        let savedEventIDs: String = UserDefaults.standard.string(forKey: "SavedEventIDs") ?? ""
        var splitSavedEventIDs: [String] = savedEventIDs.components(separatedBy: "<SEP>")
        splitSavedEventIDs.removeAll(where: { $0 == String(event.id) })
        event.saved = false
        let combinedSavedEventIDs: String = splitSavedEventIDs.joined(separator: "<SEP>")
        // save to userDefaults SavedEventIDs
        UserDefaults.standard.set(combinedSavedEventIDs, forKey: "SavedEventIDs")
        
        self.updateSavedEvents()
    }
    
    func updateSavedEvents() {
        let savedEventIDs: String = UserDefaults.standard.string(forKey: "SavedEventIDs") ?? ""
        let splitSavedEventIDs: [String] = savedEventIDs.components(separatedBy: "<SEP>")
        var matchingEvents: [Event] = []
        for savedEventID in splitSavedEventIDs {
            if let matchingEvent = self.allEvents.first(where: { $0.id == Int(savedEventID) }) {
                matchingEvent.saved = true
                matchingEvents.append(matchingEvent)
            }
        }
        withAnimation {
            self.savedEvents = matchingEvents
            self.savedOngoingEvents = matchingEvents.filter { $0.relativeTimeDate.isOngoing || $0.relativeTimeDate.isEventOver }
        }
//        print("update saved: \(self.savedEvents)")
    }
    
    func addMedal(event: Event) {
        // add Medal struct to UserDefaults
        let medal: CompletedEvent = CompletedEvent(id: event.id, sport: event.title, category: event.sortCategory, icon: event.symbol, date: event.relativeTimeDate.startDate)
        let medalString: String = UserDefaults.standard.string(forKey: "Medals") ?? ""
        var splitMedalString: [String] = medalString.components(separatedBy: "<SEP>")
        let thisMedal: String = medal.toString()
        if splitMedalString.contains(thisMedal) { return }
        splitMedalString.append(medal.toString())
        let joinedMedalString: String = splitMedalString.joined(separator: "<SEP>")
        UserDefaults.standard.set(joinedMedalString, forKey: "Medals")
        self.updateMedalsCollected()
    }
    
    func updateMedalsCollected() {
        Task.detached {
            let medalsFetched = UserDefaults.standard.string(forKey: "Medals") ?? ""
            let splitMedals: [String] = medalsFetched.components(separatedBy: "<SEP>")
            var completedEvents: [CompletedEvent] = []
            splitMedals.forEach { medalString in
                let completedEvent: CompletedEvent? = try? CompletedEvent(from: medalString)
                if let completedEvent = completedEvent {
                    // dismiss if completedEvents doesnt contain completedEvent.id
                    if !completedEvents.contains(where: { $0.id == completedEvent.id }) {
                        completedEvents.append(completedEvent)
                    }
                }
            }
            // add all medals
            var medals: [Medal] = []
            for i in self.categories {
                medals.append(Medal(category: i.title, icon: i.symbol, possibleEvents: completedEvents))
            }
            DispatchQueue.main.async {
                self.medalsCollected = medals
            }
        }
    }
    
    func clearAllMedals() {
        UserDefaults.standard.set("", forKey: "Medals")
        self.updateMedalsCollected()
    }
}

