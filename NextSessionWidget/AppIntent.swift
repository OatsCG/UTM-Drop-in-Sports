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
    case cycling = "Cycling"
    case squash = "Squash"
    case badminton = "Badminton"
    case pickleball = "Pickleball"
    case fieldsports = "Field Sports"
    case pool = "Pool"
    case rowfit = "Rowfit"
    case workout = "Workout"
    case cardio = "Cardio"
    case mindbody = "Mind & Body"
    case dance = "Dance"
    case walks = "UTM Walks"

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Category Options"
    }

    static var caseDisplayRepresentations: [Self: DisplayRepresentation] {
        [
            .volleyball: "Volleyball",
            .basketball: "Basketball",
            .soccer: "Soccer",
            .tennis: "Tennis",
            .cricket: "Cricket",
            .tabletennis: "Table Tennis",
            .cycling: "Cycling",
            .squash: "Squash",
            .badminton: "Badminton",
            .pickleball: "Pickleball",
            .fieldsports: "Field Sports",
            .pool: "Pool",
            .rowfit: "Rowfit",
            .workout: "Workout",
            .cardio: "Cardio",
            .mindbody: "Mind & Body",
            .dance: "Dance",
            .walks: "UTM Walks"
        ]
    }
}



struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    // An example configurable parameter.
    @Parameter(title: "Sport Category", default: CategoryOption.soccer)
    var category: CategoryOption?
}
