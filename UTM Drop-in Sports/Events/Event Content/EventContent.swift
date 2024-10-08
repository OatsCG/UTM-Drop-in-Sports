//
//  EventContent.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct EventContent: View {
    @Binding var showingSheet: Bool
    @Binding var event: Event
    var body: some View {
        VStack {
            Button(action: {
                showingSheet = false
            }) {
                Image(systemName: "chevron.compact.down")
                    .foregroundStyle(.tertiary)
                    .font(.title)
            }
            .buttonStyle(.plain)
            .padding()
            
            ScrollView {
                if #available(iOS 17.0, *) {
                    VStack {
                        EventImage(event: event)
                            .padding(.bottom, 18)
                        EventHeader(event: event)
                        Divider()
                            .padding(.vertical, 15)
                        EventBody(event: event)
                    }
                    .padding(.bottom, 50)
                    .safeAreaPadding()
                } else {
                    VStack {
                        EventImage(event: event)
                            .padding(.bottom, 18)
                        VStack {
                            EventHeader(event: event)
                            Divider()
                                .padding(.vertical, 15)
                            EventBody(event: event)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 50)
                    }
                }
            }
        }
    }
}
