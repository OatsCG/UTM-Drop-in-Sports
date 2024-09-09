//
//  EventHeader.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import SwiftUI

struct EventHeader: View {
    var event: Event
    var body: some View {
        HStack(alignment: .center) {
            // soccerball of color #11264b
            Image(systemName: event.symbol)
                .font(.largeTitle)
            Text(event.title)
                .font(.title .bold())
            Spacer()
        }
        .foregroundStyle(.blueUTM)
        //.foregroundStyle(Color(red: 0.06666666666666667, green: 0.14901960784313725, blue: 0.29411764705882354))
        //.foregroundStyle(Color(hue: 0.67, saturation: 0.05, brightness: 1.0))
        
        .padding(.bottom, 10)
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
            .padding(.bottom, 4)
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "clock")
                            .symbolRenderingMode(.hierarchical)
                        Text(event.relativeTimeDate.timeString)
                    }
                    HStack {
                        Image(systemName: "clock")
                            .symbolRenderingMode(.hierarchical)
                            .opacity(0)
                        Text(event.relativeTimeDate.timeLeftString)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundStyle(.secondary)
                        Text(event.relativeTimeDate.dateString)
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text(event.relativeTimeDate.daysLeftString)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            .font(.footnote)
            .foregroundStyle(.primary)
            
        }
        .padding(.leading, 10)
    }
}

#Preview {
    ContentView()
}
