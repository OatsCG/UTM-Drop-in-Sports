//
//  EventList.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct EventList: View {
    @State var allEvents: AllEvents?
    var body: some View {
        VStack {
            ForEach(0..<10) { _ in
                EventCard()
            }
        }
    }
}

#Preview {
    ContentView()
}
