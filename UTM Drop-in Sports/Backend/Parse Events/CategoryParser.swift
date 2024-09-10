//
//  File.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import SwiftUI

@Observable
class CategoryParser {
    private var allEvents: [Event] = []
    
    var categories: [Category] = []
    var events: [Event] = []
    var groupedEvents: AllEvents = AllEvents(events: [])
    var isUpdating: Bool = true
    
    var onlyWomens: Bool = false
    
    var searchField: String = ""
    
    init() {
        Task {
            await self.eventFileFetcher()
            let eventJSON: EventJSON? = loadEventJSON()
            if let eventJSON = eventJSON {
                await MainActor.run {
                    withAnimation {
                        self.categories = eventJSON.categories
                        self.allEvents = eventJSON.events
                    }
                    self.updateDisplayEvents()
                }
            }
        }
    }

    func eventFileFetcher() async {
        let userDefaults = UserDefaults.standard
        let versionURL = URL(string: "https://raw.githubusercontent.com/OatsCG/UTM-Drop-Ins-Schedule/main/version.txt")!
        let eventsURL = URL(string: "https://raw.githubusercontent.com/OatsCG/UTM-Drop-Ins-Schedule/main/events.json")!
        
        // Fetch version.txt content from the remote server
        do {
            let (versionData, _) = try await URLSession.shared.data(from: versionURL)
            guard let fetchedVersion = String(data: versionData, encoding: .utf8) else { return }
            
            // Compare with stored version
            let storedVersion = userDefaults.string(forKey: "version.txt")
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

    
    func updateDisplayEvents() {
        let notOverEvents: [Event] = self.allEvents.filter { $0.relativeTimeDate.isEventOver == false }
        let womensRespectedEvents: [Event] = notOverEvents.filter { !self.onlyWomens || $0.womens }
        var searchedEvents: [Event] = []
        for event in womensRespectedEvents {
            if event.title.lowercased().contains(self.searchField.lowercased()) || event.description.lowercased().contains(self.searchField.lowercased()) || self.searchField == "" {
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
            self.groupedEvents = AllEvents(events: self.events)
        }
    }
}
