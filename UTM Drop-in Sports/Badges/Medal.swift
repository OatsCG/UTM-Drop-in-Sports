//
//  Medal.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-10-07.
//

import Foundation
import SwiftUI


struct CompletedEvent: Equatable, Hashable {
    var id: Int
    var sport: String
    var category: String
    var icon: String
    var date: Date
    
    init(id: Int, sport: String, category: String, icon: String, date: Date) {
        self.sport = sport
        self.category = category
        self.icon = icon
        self.date = date
        self.id = id
    }
    
    init (from formatted: String) throws {
        let separated = formatted.components(separatedBy: "<MSEP>")
        guard separated.count == 5 else {
            throw NSError()
        }
        if let id = Int(separated[0]) {
            self.id = id
        } else {
            self.id = 0
        }
        self.sport = String(separated[1])
        self.category = String(separated[2])
        self.icon = String(separated[3])
        if let timeInterval = Double(separated[4]) {
            self.date = Date(timeIntervalSince1970: timeInterval)
        } else {
            self.date = Date()
        }
    }
    
    func toString() -> String {
        return "\(id)<MSEP>\(sport)<MSEP>\(category)<MSEP>\(icon)<MSEP>\(date.timeIntervalSince1970)"
    }
}


struct Medal: Equatable, Hashable {
    var type: MedalType
    var category: String
    var icon: String
    var events: [CompletedEvent]
    
    var colorPrimary: Color {
        switch type {
        case .gold:
            return .yellow
        case .silver:
            return .white
        case .bronze:
            return .orange
        case .none:
            return .clear
        }
    }
    var colorSecondary: Color {
        switch type {
        case .gold:
            return .orange
        case .silver:
            return .gray
        case .bronze:
            return .orange
        case .none:
            return .clear
        }
    }
    
    init(category: String, icon: String, possibleEvents: [CompletedEvent]) {
        self.type = .none
        self.category = category
        self.icon = icon
        self.events = []
        self.events = possibleEvents.filter { self.category == $0.category }
        if self.events.count > 0 {
            if self.events.count >= 5 {
                if self.events.count >= 10 {
                    self.type = .gold
                } else {
                    self.type = .silver
                }
            } else {
                self.type = .bronze
            }
        } else {
            self.type = .none
        }
//        self.type = MedalType.allCases.randomElement()!
        
    }
}

enum MedalType: CaseIterable {
    case gold, silver, bronze, none
}
