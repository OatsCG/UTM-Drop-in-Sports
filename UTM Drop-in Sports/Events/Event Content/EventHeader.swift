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
            if #available (iOS 17.0, *) {
                Image(systemName: event.symbol)
                    .font(.largeTitle)
            } else {
                Image(event.symbol)
                    .font(.largeTitle)
            }
            Text(event.title)
                .font(.title .bold())
            Spacer()
        }
        .foregroundStyle(.blueUTM)
        .padding(.bottom, 10)
        
        VStack {
            HStack {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .symbolRenderingMode(.hierarchical)
                    Text(event.venue)
                }
                Spacer()
            }
            .font(.subheadline .bold())
            .padding(.bottom, 6)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    HStack {
                        if #available(iOS 16.0, *) {
                            Image(systemName: event.relativeTimeDate.daySymbol)
                                .foregroundStyle(event.relativeTimeDate.daySymbolColor.gradient)
                        } else {
                            Image(systemName: event.relativeTimeDate.daySymbol)
                                .foregroundStyle(event.relativeTimeDate.daySymbolColor)
                        }
                        Text(event.relativeTimeDate.timeString)
                    }
                    if event.relativeTimeDate.isOngoing {
                        HStack {
                            if #available(iOS 18.0, *) {
                                Image(systemName: "record.circle")
                                    .font(.caption2)
                                    .symbolEffect(.pulse .byLayer, options: .repeat(.continuous))
                            } else {
                                Image(systemName: "record.circle")
                                    .font(.caption2)
                            }
                            Text("Ongoing")
                        }
                        .foregroundStyle(.green)
                    } else if event.relativeTimeDate.isEventOver {
                        HStack {
                            Image(systemName: "clock")
                                .font(.caption2)
                            Text("Event Over")
                        }
                        .foregroundStyle(.red)
                    } else {
                        HStack {
                            Image(systemName: "clock")
                                .symbolRenderingMode(.hierarchical)
                                .opacity(0)
                            Text(event.relativeTimeDate.timeLeftString)
                                .foregroundStyle(event.relativeTimeDate.timeLeftString == "Soon" ? .orange : .secondary)
                        }
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
