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
            if categoryParser.savedEvents != [] {
                HStack {
                    Text("Marked Events")
                    Image(systemName: "bookmark")
                    Spacer()
                }
                .font(.title .bold())
                ForEach(categoryParser.savedEvents, id: \.id) { event in
                    if #available(iOS 17.0, *) {
                        EventCard(event: event)
                            .transition(.blurReplace)
                    } else {
                        EventCard(event: event)
                    }
                }
            }
        }
    }
}


#Preview {
    @State var nm = NotificationManager()
    @State var c = CategoryParser()
    return ContentView()
        .environmentObject(c)
        .environmentObject(nm)
}
