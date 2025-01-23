//
//  AppIntent.swift
//  NextSessionWidget
//
//  Created by Charlie Giannis on 2025-01-22.
//

import WidgetKit
import AppIntents

enum CategoryOption: String, AppEnum {
    case volleyball = "Volleyball"
    case basketball = "Basketball"
    case soccer = "Soccer"
    case tennis = "Tennis"
    case cricket = "Cricket"
    case tabletennis = "Table Tennis"
    case combat = "Combat"
    case cycling = "Cycling"
    case squash = "Squash"
    case badminton = "Badminton"
    case pickleball = "Pickleball"
    case fieldsports = "Field Sports"
    case hockey = "Hockey"
    case pool = "Pool"
    case rowfit = "Rowfit"
    case workout = "Workout"
    case cardio = "Cardio"
    case mindbody = "Mind & Body"
    case dance = "Dance"
    case walks = "UTM Walks"

    @available(iOS 16.0, *)
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Category Options"
    }

    @available(iOS 16.0, *)
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] {
        [
            .volleyball: "Volleyball",
            .basketball: "Basketball",
            .soccer: "Soccer",
            .tennis: "Tennis",
            .cricket: "Cricket",
            .tabletennis: "Table Tennis",
            .combat: "Combat",
            .cycling: "Cycling",
            .squash: "Squash",
            .badminton: "Badminton",
            .pickleball: "Pickleball",
            .fieldsports: "Field Sports",
            .hockey: "Hockey",
            .pool: "Pool",
            .rowfit: "Rowfit",
            .workout: "Workout",
            .cardio: "Cardio",
            .mindbody: "Mind & Body",
            .dance: "Dance",
            .walks: "UTM Walks"
        ]
    }
    
//    var displayRepresentation: String {
//        if #available(iOS 16, *), let representation = Self.caseDisplayRepresentations[self] {
//            return representation.title
//        }
//        return rawValue // Fallback for iOS versions below 16.0
//    }
}

func CategoryToDisplayRepresentation(_ category: String) -> String {
    if let c = CategoryOption(rawValue: category) {
        if #available(iOS 16, *) {
            let representation = CategoryOption.caseDisplayRepresentations[c]
            if let representation {
                return String(localized: representation.title)
            } else {
                return c.rawValue
            }
        } else {
            return c.rawValue
        }
    } else {
        return category
    }
}


@available(iOS 17.0, *)
struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    // An example configurable parameter.
    @Parameter(title: "Sport Category", default: CategoryOption.soccer)
    var category: CategoryOption?
}
