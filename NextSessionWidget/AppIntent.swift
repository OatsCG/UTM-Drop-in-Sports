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
    case swim = "Swim"
    case rowfit = "Rowfit"
    case workout = "Workout"
    case cardio = "Cardio"
    case mindbody = "Mind & Body"
    case dance = "Dance"
    case moves = "UTM Moves"

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
            .swim: "Swim",
            .rowfit: "Rowfit",
            .workout: "Workout",
            .cardio: "Cardio",
            .mindbody: "Mind & Body",
            .dance: "Dance",
            .moves: "UTM Moves"
        ]
    }
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
    static var title: LocalizedStringResource { "Next Session" }
    static var description: IntentDescription { "See the next session for your favourite sport." }

    // An example configurable parameter.
    @Parameter(title: "Sport Category", default: CategoryOption.soccer)
    var category: CategoryOption?
}
