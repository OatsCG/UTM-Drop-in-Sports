//
//  EventCard.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct EventCard: View {
    var event: Event1 = Event1()
    @State var showingSheet: Bool = false
    @Namespace var animation
    var body: some View {
        Button(action: {
            showingSheet = true
        }) {
            EventCardContent()
                .matchedTransitionSource(id: event.id, in: animation)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingSheet) {
            EventContent(showingSheet: $showingSheet, event: event)
            .navigationTransition(.zoom(sourceID: event.id, in: animation))
        }
    }
}

#Preview {
    ContentView()
}
