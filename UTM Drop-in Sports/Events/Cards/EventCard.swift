//
//  EventCard.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct EventCard: View {
    var event: Event
    @State var showingSheet: Bool = false
    @Namespace var animation
    var body: some View {
        Button(action: {
            showingSheet = true
        }) {
            if #available(iOS 18.0, *) {
                EventCardContent(event: event)
                    .matchedTransitionSource(id: event.id, in: animation)
            } else {
                EventCardContent(event: event)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingSheet) {
            if #available(iOS 18.0, *) {
                EventContent(showingSheet: $showingSheet, event: event)
                    .navigationTransition(.zoom(sourceID: event.id, in: animation))
            } else {
                EventContent(showingSheet: $showingSheet, event: event)
            }
        }
    }
}

#Preview {
    ContentView()
}
