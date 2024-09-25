//
//  ShortcutsProvider.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-25.
//

import Foundation
import AppIntents


@available(iOS 16.0, *)
struct MyAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: GetNextSportInfo(), phrases: ["When is the next \(\.$sportName) drop-in"])
    }
}


@available(iOS 16.0, *)
struct GetNextSportInfo: AppIntent {
    static var title: LocalizedStringResource = "Get Drop-In Information"
    static var description = IntentDescription("Provides details on a drop-in sport or activity.")
    
    // Define any parameters for the intent (e.g., song name)
    @Parameter(title: "Sport Name")
    var sportName: String

    // What the intent does when triggered
    func perform() async throws -> some IntentResult {
        var categoryParser: CategoryParser = CategoryParser()
        categoryParser.
        return .result()
    }
}
