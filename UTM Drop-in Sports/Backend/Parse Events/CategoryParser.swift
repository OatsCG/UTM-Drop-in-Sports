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
