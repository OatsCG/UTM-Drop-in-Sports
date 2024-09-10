//
//  UTM_Drop_in_SportsApp.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

@main
struct UTM_Drop_in_SportsApp: App {
    @StateObject var categoryParser: CategoryParser = CategoryParser()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(categoryParser)
        }
    }
}
