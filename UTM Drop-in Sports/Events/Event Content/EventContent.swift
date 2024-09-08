//
//  EventContent.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct EventContent: View {
    @Binding var showingSheet: Bool
    var event: Event
    var body: some View {
        VStack {
            Button(action: {
                showingSheet = false
            }) {
                // down chevron sfsymbol
                Image(systemName: "chevron.compact.down")
                    .foregroundStyle(.tertiary)
                    .font(.title)
            }
            .buttonStyle(.plain)
            .padding()
            
            ScrollView {
                VStack {
                    EventImage()
                        .padding(.bottom, 18)
                    EventHeader()
                    Divider()
                        .padding(.vertical, 15)
                    EventBody()
                }
                .safeAreaPadding()
            }
        }
    }
}

#Preview {
    EventContent(showingSheet: .constant(true), event: Event())
}
