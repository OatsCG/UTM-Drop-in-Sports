//
//  Event.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import Foundation


struct DayEvents: Hashable {
    static func == (lhs: DayEvents, rhs: DayEvents) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    let id: UUID = UUID()
    let date: Date
    var events: [Event]
    
    init(date: Date, events: [Event]) {
        self.date = date
        self.events = events
    }
}

class AllEvents {
    var days: [DayEvents] = []
    
    
    init(events: [Event]) {
        var dayEventsList: [DayEvents] = []
            
            // Helper to get just the day from a Date
        let calendar = Calendar.current
        
        var currentDayEvents: DayEvents?
        
        for event in events {
            let eventDate = calendar.startOfDay(for: event.relativeTimeDate.startDate)
            
            if let currentDay = currentDayEvents?.date, currentDay == eventDate {
                // Add event to the current DayEvents if it's the same day
                currentDayEvents?.events.append(event)
            } else {
                // Close off the previous DayEvents, if any, and start a new one
                if let currentDayEvents = currentDayEvents {
                    dayEventsList.append(currentDayEvents)
                }
                currentDayEvents = DayEvents(date: eventDate, events: [event])
            }
        }
        
        // Add the final DayEvents object if there are remaining events
        if let currentDayEvents = currentDayEvents {
            dayEventsList.append(currentDayEvents)
        }
        
        self.days = dayEventsList
    }
}
