//
//  ParseEvents.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import SwiftUI

func loadEventJSON() -> EventJSON? {
    let fileManager = FileManager.default
    if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
        let eventsFileURL = documentsDirectory.appendingPathComponent("events.json")
        
        do {
            let data = try Data(contentsOf: eventsFileURL)
            let decoder = JSONDecoder()
            let eventJSON = try decoder.decode(EventJSON.self, from: data)
            return eventJSON
        } catch {
            print("Error loading or decoding events.json: \(error)")
        }
    }
    return nil
}


class EventJSON: Decodable {
    let categories: [Category]
    let events: [Event]
    let featured: [Event]
    let announcements: [Announcement]
    let allCategories: [Category]
}


class Announcement: Decodable, Hashable, ObservableObject {
    var id: Int
    var title: String
    var body: String
    var seen: Bool
    
    static func == (lhs: Announcement, rhs: Announcement) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        body = try values.decode(String.self, forKey: .body)
        seen = false
        if UserDefaults.standard.bool(forKey: "\(id)") {
            seen = true
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
    }
    
    func markAsSeen() {
        self.seen = true
        UserDefaults.standard.set(true, forKey: "\(id)")
    }
}

class Category: Decodable, Hashable, ObservableObject {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        symbol = try values.decode(String.self, forKey: .symbol)
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case symbol
    }
    
    var id: UUID = UUID()
    let title: String
    let symbol: String
    @Published var selected: Bool = false
    @Published var shown: Bool = false
}


class Event: ObservableObject, Decodable, Hashable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        url = try values.decode(String.self, forKey: .url)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        image = try values.decode(String.self, forKey: .image)
        start_date = try values.decode(String.self, forKey: .start_date)
        end_date = try values.decode(String.self, forKey: .end_date)
        venue = try values.decode(String.self, forKey: .venue)
        ticket_label = try values.decode(String.self, forKey: .ticket_label)
        ticket_url = try values.decode(String.self, forKey: .ticket_url)
        sortCategory = try values.decode(String.self, forKey: .sortCategory)
        symbol = try values.decode(String.self, forKey: .symbol)
        womens = try values.decode(Bool.self, forKey: .womens)
        weeklyRepetitions = try values.decode([String].self, forKey: .weeklyRepetitions)
        relativeTimeDate = formatDateRange(startDate: start_date, endDate: end_date)
        saved = false
        lgbt = self.description.contains("LGBT") || self.description.contains("LGTB") || self.description.contains("2SL")
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case url
        case title
        case description
        case image
        case start_date
        case end_date
        case venue
        case ticket_label
        case ticket_url
        case sortCategory
        case symbol
        case womens
        case weeklyRepetitions
    }
  
    @Published var relativeTimeDate: RelativeTimeDate
    @Published var saved: Bool
    var id: Int
    let url: String
    let title: String
    let description: String
    let image: String
    let start_date: String
    let end_date: String
    let venue: String
    let ticket_label: String
    let ticket_url: String
    let sortCategory: String
    let symbol: String
    let womens: Bool
    let weeklyRepetitions: [String]
    let lgbt: Bool
}


import Foundation

struct RelativeTimeDate {
    let startDate: Date
    let timeString: String
    let dateString: String
    let daysLeftString: String
    let timeLeftString: String
    let isOngoing: Bool
    let isEventOver: Bool
    let daySymbol: String
    let daySymbolColor: Color
}

func formatDateRange(startDate: String, endDate: String) -> RelativeTimeDate {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    guard let start = dateFormatter.date(from: startDate),
          let end = dateFormatter.date(from: endDate) else {
        return RelativeTimeDate(startDate: Date(), timeString: "", dateString: "", daysLeftString: "", timeLeftString: "", isOngoing: false, isEventOver: false, daySymbol: "", daySymbolColor: .primary)
    }
    
    let now = Date()
    // Time String (e.g., "9:00am - 10:00am")
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h:mma"
    let startTime = timeFormatter.string(from: start).lowercased()
    let endTime = timeFormatter.string(from: end).lowercased()
    let timeString = "\(startTime) - \(endTime)"
    
    // Date String (e.g., "Tuesday Sept 2")
    let dateFormatterForDateString = DateFormatter()
    dateFormatterForDateString.dateFormat = "EEEE MMM d"
    let dateString = dateFormatterForDateString.string(from: start)
    
    // Days Left String (e.g., "Today", "Tomorrow", "")
    let calendar = Calendar.current
    let daysLeftString: String
    let hoursLeft: Int = Int(round(start.timeIntervalSince(now) / 3600))
    var timeLeftString: String = ""
    if hoursLeft >= 0 {
        if hoursLeft <= 1 {
            timeLeftString = "Soon"
        } else if hoursLeft <= 24 {
            timeLeftString = "In \(hoursLeft) hours"
        }
    }
    
    //let timeLeftString = hoursLeft <= 5 ? "\(hoursLeft) \(hoursLeft == 1 ? "hour" : "hours") left" : ""
    
    if calendar.isDateInToday(start) {
        daysLeftString = "Today"
    } else if calendar.isDateInTomorrow(start) {
        daysLeftString = "Tomorrow"
    } else {
        daysLeftString = ""
    }
    
    // isOngoing
    let isOngoing = now >= start && now <= end
    
    // isEventOver
    let isEventOver = now > end
    
    return RelativeTimeDate(startDate: start, timeString: timeString, dateString: dateString, daysLeftString: daysLeftString, timeLeftString: timeLeftString, isOngoing: isOngoing, isEventOver: isEventOver, daySymbol: getDaySection(start, end), daySymbolColor: getDayColor(start, end))
}

func getDaySection(_ startDate: Date, _ endDate: Date) -> String {
    let middleDate = startDate.addingTimeInterval(endDate.timeIntervalSince(startDate) / 2)
    
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: middleDate)

    switch hour {
    case 6..<12:
        return "sunrise"
    case 12..<18:
        return "sun.max"
    default:
        return "moon"
    }
}

func getDayColor(_ startDate: Date, _ endDate: Date) -> Color {
    let middleDate = startDate.addingTimeInterval(endDate.timeIntervalSince(startDate) / 2)
    
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: middleDate)

    switch hour {
    case 6..<12:
        return .orange
    case 12..<18:
        return .yellow
    default:
        return .blue
    }
}



#Preview {
    ContentView()
}
