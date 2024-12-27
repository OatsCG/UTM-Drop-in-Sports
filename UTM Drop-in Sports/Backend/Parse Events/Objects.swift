//
//  Event.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import Foundation

class DayEvents: ObservableObject, Hashable {
    static func == (lhs: DayEvents, rhs: DayEvents) -> Bool {
        return lhs.date == rhs.date
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.date)
    }
    
    @Published var date: Date
    @Published var events: [Event]
    
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


class DynamicRow: ObservableObject, Hashable {
    @Published var id: Int
    @Published var events: [Event]
    
    init(events: [Event]) {
        var tempid: Int = 0
        self.events = events
        for event in events {
            tempid += event.id
        }
        self.id = tempid
    }
    
    static func ==(lhs: DynamicRow, rhs: DynamicRow) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
