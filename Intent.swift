//
//  Intent.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-30.
//

import Foundation
import AppIntents

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct Intent: AppIntent, CustomIntentMigratedAppIntent, PredictableIntent {
    static let intentClassName = "IntentIntent"

    static var title: LocalizedStringResource = "Get Drop In Information"
    static var description = IntentDescription("Provides details on a drop-in sport or activity.")

    @Parameter(title: "Sport")
    var sport: String?

    static var parameterSummary: some ParameterSummary {
        Summary("View Next \(\.$sport) Drop-In")
    }

    static var predictionConfiguration: some IntentPredictionConfiguration {
        IntentPrediction(parameters: (\.$sport)) { sport in
            DisplayRepresentation(
                title: "View Next \(sport!) Drop-In",
                subtitle: "Provides details on a drop-in sport or activity."
            )
        }
    }

    func perform() async throws -> some IntentResult {
        // TODO: Place your refactored intent handler code here.
        return .result()
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
fileprivate extension IntentDialog {
    static var sportParameterPrompt: Self {
        "Which sport are you looking for?"
    }
    static func sportParameterDisambiguationIntro(count: Int, sport: String) -> Self {
        "There are \(count) options matching ‘\(sport)’."
    }
    static func sportParameterConfirmation(sport: String) -> Self {
        "Just to confirm, you wanted ‘\(sport)’?"
    }
    static var responseSuccess: Self {
        "Ok, this succeeded."
    }
    static var responseFailure: Self {
        "Ok, this failed."
    }
}

