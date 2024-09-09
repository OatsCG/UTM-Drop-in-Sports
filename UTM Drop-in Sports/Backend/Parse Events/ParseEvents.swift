//
//  ParseEvents.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import Foundation

func loadEventJSON() -> EventJSON? {
    guard let fileURL = Bundle.main.url(forResource: "events", withExtension: "json") else {
        print("File not found: events.json")
        return nil
    }
    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(EventJSON.self, from: data)
        return decodedData
    } catch {
        print("Error reading or parsing file: \(error)")
        return nil
    }
}


class EventJSON: Decodable {
    let categories: [Category]
    let events: [Event]
}


@Observable
class Category: Decodable, Hashable {
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
    var selected: Bool = false
}

@Observable
class Event: Decodable, Hashable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
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
        relativeTimeDate = formatDateRange(startDate: start_date, endDate: end_date)
    }
    
    private enum CodingKeys: String, CodingKey {
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
    }
  
    var id: UUID = UUID()
    var relativeTimeDate: RelativeTimeDate
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
}

func formatDateRange(startDate: String, endDate: String) -> RelativeTimeDate {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    guard let start = dateFormatter.date(from: startDate),
          let end = dateFormatter.date(from: endDate) else {
        return RelativeTimeDate(startDate: Date(), timeString: "", dateString: "", daysLeftString: "", timeLeftString: "", isOngoing: false, isEventOver: false)
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
    let timeLeftString: String
    
    if calendar.isDateInToday(start) {
        daysLeftString = "Today"
        timeLeftString = "" // No time left string for today
    } else if calendar.isDateInTomorrow(start) {
        daysLeftString = "Tomorrow"
        let hoursLeft = Int(start.timeIntervalSince(now) / 3600)
        timeLeftString = hoursLeft <= 5 ? "\(hoursLeft) \(hoursLeft == 1 ? "hour" : "hours") left" : ""
    } else {
        daysLeftString = ""
        let hoursLeft = Int(start.timeIntervalSince(now) / 3600)
        timeLeftString = hoursLeft <= 5 ? "\(hoursLeft) \(hoursLeft == 1 ? "hour" : "hours") left" : ""
    }
    
    // isOngoing
    let isOngoing = now >= start && now <= end
    
    // isEventOver
    let isEventOver = now > end
    
    return RelativeTimeDate(startDate: start, timeString: timeString, dateString: dateString, daysLeftString: daysLeftString, timeLeftString: timeLeftString, isOngoing: isOngoing, isEventOver: isEventOver)
}
