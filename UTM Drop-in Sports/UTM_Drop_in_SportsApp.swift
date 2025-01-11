//
//  UTM_Drop_in_SportsApp.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI
import GoogleMobileAds

@main
struct UTM_Drop_in_SportsApp: App {
    @StateObject var categoryParser: CategoryParser = CategoryParser()
    @StateObject var notificationManager: NotificationManager = NotificationManager()
    
    init() {
        GADMobileAds.sharedInstance().start { status in
//            print("AdMob initialized with status: \(status.adapterStatusesByClassName)")
//            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "80a17b0aa096333d6e38d4218bd0be75" ]
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notificationManager)
                .environmentObject(categoryParser)
        }
    }
}
