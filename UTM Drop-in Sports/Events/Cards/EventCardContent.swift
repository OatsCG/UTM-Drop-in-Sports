//
//  EventCardContent.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct EventCardContent: View {
    var event: Event
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image(systemName: event.symbol)
                    .font(.title)
                Text(event.title)
                    .font(.title3 .bold())
                Spacer()
            }
            .foregroundStyle(.blueUTM)
            Spacer()
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "map")
                            .symbolRenderingMode(.hierarchical)
                        Text(event.venue)
                    }
                    Spacer()
                }
                    .font(.subheadline .bold())
                    .padding(.bottom, 2)
                HStack {
                    Image(systemName: "clock")
                        .symbolRenderingMode(.hierarchical)
                    Text(event.relativeTimeDate.timeString)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundStyle(.secondary)
                    Text(event.relativeTimeDate.dateString)
                        .foregroundStyle(.secondary)
                }
                    .font(.footnote)
                    .foregroundStyle(.primary)
                
            }
            .padding(.leading, 10)
        }
        .padding(15)
        .background {
            RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous).fill(.clear)
                .stroke(.tertiary, lineWidth: 2)
        }
        .contentShape(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous))
        .clipShape(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous))
        .frame(height: 120)
    }
}

#Preview {
    ContentView()
}
