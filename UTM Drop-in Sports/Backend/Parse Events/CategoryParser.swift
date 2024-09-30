//
//  File.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import SwiftUI

class CategoryParser: ObservableObject {
    private var allEvents: [Event] = []
    
    @Published var categories: [Category] = []
    @Published var events: [Event] = []
    @Published var groupedEvents: AllEvents = AllEvents(events: [], maxDays: nil)
    @Published var isUpdating: Bool = true
    @Published var onlyWomens: Bool = false
    @Published var isEventsExpandedToMax: Bool = false
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
                    withAnimation {
                        self.categories = eventJSON.categories
                    }
                    self.allEvents = eventJSON.events
                    self.lastUpdated = Date()
                    self.updateDisplayEvents(maxDays: 14)
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
            self.lastUpdated = Date()
            self.updateDisplayEvents(maxDays: 14)
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
        return timeInterval <= 600 // 600 seconds = 10 minutes
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

    
    func updateDisplayEvents(maxDays: Int?) {
        let notOverEvents: [Event] = self.allEvents.filter { $0.relativeTimeDate.isEventOver == false }
        let womensRespectedEvents: [Event] = notOverEvents.filter { !self.onlyWomens || $0.womens }
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
        if selectedCategories.count == 0 {
            withAnimation {
                self.events = searchedEvents
            }
        } else {
            var allowedEvents: [Event] = []
            for event in searchedEvents {
                if selectedCategories.contains(where: { $0.title == event.sortCategory }) {
                    allowedEvents.append(event)
                }
            }
            withAnimation {
                self.events = allowedEvents
            }
        }
        withAnimation {
            self.isUpdating = false
            if let maxDays = maxDays {
                self.groupedEvents = AllEvents(events: self.events, maxDays: maxDays)
                self.isEventsExpandedToMax = false
            } else {
                self.groupedEvents = AllEvents(events: self.events, maxDays: nil)
                self.isEventsExpandedToMax = true
            }
        }
    }
}

