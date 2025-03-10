//
//  ShortcutsProvider.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-25.
//

import AppIntents
import SwiftUI

@available(iOS 16.0, *)
struct MyAppShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: GetNextSportInfo(), phrases: [
            "Get information with \(.applicationName)",
            "Get times with \(.applicationName)"
//            "Get the next \(\.$sport) drop in using \(.applicationName)"
        ])
    }
}

@available(iOS 16.0, *)
struct GetNextSportInfo: AppIntent {
    static var title: LocalizedStringResource = "Get Session Information"
    static var description = IntentDescription("Provides details on a sport or activity.")
    
    @Parameter(title: "Sport Name")
    var sport: String?

    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        // Instantiate your CategoryParser and get the events
        let categoryParser: CategoryParser = await CategoryParser()
        let events: [Event] = categoryParser.events
        let sportToRun: String
        if let sport = self.sport {
            sportToRun = sport
        } else {
            // Handle disambiguation request with await and try outside of the assignment
            let categories = categoryParser.categories.map { CategoryToDisplayRepresentation($0.title) }
            sportToRun = try await $sport.requestDisambiguation(
                among: categories,
                dialog: IntentDialog("What session would you like?")
            )
        }
        
        // Find the first event where the sport name matches
        if let event = events.first(where: { $0.sortCategory == sportToRun }) {
            // Siri will speak the event name
            // Return the event in a view (EventCardView)
            return .result(dialog: "The next \(CategoryToDisplayRepresentation(sportToRun)) session is \(formattedDateString(from: event.start_date)) at \(formattedTimeString(from: event.start_date)).", view: EventCardSiri(event: event))
        } else {
            // Handle case where no event is found
            return .result(dialog: "I couldn't find any upcoming sessions for \(CategoryToDisplayRepresentation(sportToRun)).")
        }
    }
}

//@available(iOS 16.0, *)
//struct SportEntity: AppEntity {
//    var id: UUID
//    var name: String
//
//    var displayRepresentation: DisplayRepresentation {
//        DisplayRepresentation(title: "\(name)")
//    }
//    static var typeDisplayRepresentation: TypeDisplayRepresentation {
//        TypeDisplayRepresentation(name: "Sport")
//    }
//
//    static var defaultQuery = SportQuery()
//}

// Define the query to fetch available sports
//@available(iOS 16.0, *)
//struct SportQuery: EntityQuery {
//    func entities(for identifiers: [UUID]) async throws -> [SportEntity] {
//        let allSports = [
//            SportEntity(id: UUID(), name: "Basketball"),
//            SportEntity(id: UUID(), name: "Soccer"),
//            SportEntity(id: UUID(), name: "Volleyball")
//        ]
//        return allSports.filter { identifiers.contains($0.id) }
//    }
//}

func formattedDateString(from dateString: String) -> String {
    // Date formatter for the input date string
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone.current
    
    // Date formatter for output like "on Monday October 16"
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "EEEE MMMM d"
    
    // Parse the input string to a Date
    guard let date = dateFormatter.date(from: dateString) else {
        return ""
    }
    
    let calendar = Calendar.current
    let today = Date()
    
    // Calculate the difference in days between today and the input date
    let daysDifference = calendar.dateComponents([.day], from: today, to: date).day ?? Int.max
    
    if calendar.isDateInToday(date) {
        return "today"
    } else if daysDifference == 1 {
        return "tomorrow"
    } else if daysDifference > 1 && daysDifference <= 6 {
        // Output "this Monday" or other weekday
        let weekday = calendar.component(.weekday, from: date)
        let weekdayName = outputFormatter.weekdaySymbols[weekday - 1]
        return "this \(weekdayName)"
    } else if daysDifference > 6 {
        // Output "on Monday October 16" or similar format
        return "on \(outputFormatter.string(from: date))"
    }
    
    return ""
}

func formattedTimeString(from dateString: String) -> String {
    // Date formatter for the input date string
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone.current
    
    // Date formatter for output time like "11:30am"
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h:mma"
    timeFormatter.amSymbol = "am"
    timeFormatter.pmSymbol = "pm"
    
    // Parse the input string to a Date
    guard let date = dateFormatter.date(from: dateString) else {
        return ""
    }
    
    // Return the formatted time string
    return timeFormatter.string(from: date).lowercased()
}

