//
//  MarkedEvents.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-10-05.
//

import SwiftUI

struct SavedEvents: View {
    @EnvironmentObject var categoryParser: CategoryParser
    var body: some View {
        VStack {
            HStack {
                Text("Marked Events")
                Image(systemName: "bookmark")
                Spacer()
            }
            .font(.title .bold())
            VStack {
                if let e = categoryParser.events.first {
                    EventCard(event: e)
                }
//                categoryParser.events.first?
            }
        }
    }
}

#Preview {
    SavedEvents()
}

#Preview {
    @State var nm = NotificationManager()
    @State var c = CategoryParser()
    return ContentView()
        .environmentObject(c)
        .environmentObject(nm)
}
