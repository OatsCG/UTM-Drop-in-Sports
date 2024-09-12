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
    
    
    init(events: [Event], maxDays: Int?) {
        var dayEventsList: [DayEvents] = []
        
        let calendar = Calendar.current
        
        var currentDayEvents: DayEvents?
        
        for event in events {
            let eventDate = calendar.startOfDay(for: event.relativeTimeDate.startDate)
            
            if let currentDay = currentDayEvents?.date, currentDay == eventDate {
                currentDayEvents?.events.append(event)
            } else {
                if let currentDayEvents = currentDayEvents {
                    dayEventsList.append(currentDayEvents)
                }
                currentDayEvents = DayEvents(date: eventDate, events: [event])
            }
        }
        
        if let currentDayEvents = currentDayEvents {
            dayEventsList.append(currentDayEvents)
        }
        if let maxDays = maxDays {
            self.days = Array(dayEventsList.prefix(maxDays))
        } else {
            self.days = dayEventsList
        }
    }
}
