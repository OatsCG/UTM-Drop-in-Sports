//
//  Event.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import Foundation


struct Event1: Hashable {
    let id: UUID = UUID()
    let name: String
    let date: Date
    let location: String
    let description: String
    
    init() {
        self.name = "Event Name"
        self.date = Date()
        self.location = "Event Location"
        self.description = "Event Description"
    }
}

struct DayEvents: Hashable {
    let id: UUID = UUID()
    let date: Date
    let events: [Event1]
    
    init() {
        self.date = Date()
        self.events = [Event1(), Event1(), Event1()]
    }
}

struct AllEvents: Hashable {
    let days: [DayEvents]
    
    init() {
        self.days = [DayEvents(), DayEvents(), DayEvents()]
    }
}
