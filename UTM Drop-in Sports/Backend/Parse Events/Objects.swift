//
//  Event.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import Foundation
import SwiftUI

class DayEvents: ObservableObject, Hashable {
    static func == (lhs: DayEvents, rhs: DayEvents) -> Bool {
        return lhs.date == rhs.date
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.date)
    }
    
    @Published var date: Date
    @Published var events: [Event]
    @Published var rows: [DynamicRow]
    
    init(date: Date, events: [Event], columnCount: Int) {
        self.date = date
        self.events = events
        self.rows = []
//        self.updateRows(columnCount: columnCount)
    }
    
    func updateRows(columnCount: Int, animate: Bool = true) {
        return
        
        var rows: [DynamicRow] = []
        for rowIndex in 0..<rowsCount(columnCount: columnCount) {
            var thisRowsEvents: [Event] = []
            let startIndex = rowIndex * columnCount
            let endIndex = startIndex + columnCount
//            print("COUNT: \(self.events.count)")
            for eventIndex in startIndex..<endIndex {
                guard eventIndex < self.events.count else { break }
                thisRowsEvents.append(self.events[eventIndex])
            }
            rows.append(.init(events: thisRowsEvents))
        }
        if animate {
            withAnimation {
                self.rows = rows
            }
        } else {
            self.rows = rows
        }
    }
    
    private func rowsCount(columnCount: Int) -> Int {
        return (self.events.count + columnCount - 1) / columnCount
    }
}

class AllEvents: ObservableObject {
    @Published var days: [DayEvents] = []
    
    init(events: [Event], maxEvents: Int?, columnCount: Int) {
        var dayEventsList: [DayEvents] = []
        
        let calendar = Calendar.current
        
        var currentDayEvents: DayEvents?
        
        for event in events.prefix(maxEvents ?? 1000) {
            let eventDate = calendar.startOfDay(for: event.relativeTimeDate.startDate)
            
            if let currentDay = currentDayEvents?.date, currentDay == eventDate {
                currentDayEvents?.events.append(event)
            } else {
                if let currentDayEvents = currentDayEvents {
                    currentDayEvents.updateRows(columnCount: columnCount)
                    dayEventsList.append(currentDayEvents)
                }
                currentDayEvents = DayEvents(date: eventDate, events: [event], columnCount: columnCount)
            }
        }
        
        if let currentDayEvents = currentDayEvents {
            currentDayEvents.updateRows(columnCount: columnCount)
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
