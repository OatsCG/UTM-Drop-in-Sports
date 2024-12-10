//
//  Event.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import Foundation

struct DayEvents: Hashable {
    static func == (lhs: DayEvents, rhs: DayEvents) -> Bool {
        return lhs.date == rhs.date
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.date)
    }
    
    let date: Date
    var events: [Event]
    
    init(date: Date, events: [Event]) {
        self.date = date
        self.events = events
    }
}

class AllEvents: ObservableObject {
    @Published var days: [DayEvents] = []
    
    init(events: [Event], maxEvents: Int?) {
        var dayEventsList: [DayEvents] = []
        
        let calendar = Calendar.current
        
        var currentDayEvents: DayEvents?
        
        for event in events.prefix(maxEvents ?? 1000) {
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
        self.days = dayEventsList
    }
}


class DynamicRow: Hashable {
    var id: Int
    var events: [Event]
    
    init(events: [Event]) {
        self.id = 0
        for event in events {
            self.id += event.id
        }
        self.events = events
    }
    
    static func ==(lhs: DynamicRow, rhs: DynamicRow) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
