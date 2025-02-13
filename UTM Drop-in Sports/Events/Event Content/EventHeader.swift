//
//  EventHeader.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import SwiftUI

struct EventHeader: View {
    @Environment(\.colorScheme) private var colorScheme
    var event: Event
    var body: some View {
        HStack(alignment: .center) {
            if event.lgbt {
                SymbolImage(event.symbol)
                    .font(.largeTitle)
                    .foregroundStyle(AngularGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red], center: .center))
                    .overlay {
                        SymbolImage(event.symbol)
                            .font(.largeTitle)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .opacity(colorScheme == .dark ? 0.25 : 0.15)
                        
                    }
            } else {
                SymbolImage(event.symbol)
                    .font(.largeTitle)
                    .foregroundStyle(event.womens ? .pinkUTM : .blueUTM)
            }
            Text(event.title)
                .font(.title .bold())
                .foregroundStyle(.blueUTM)
            Spacer()
        }
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
                            Image(systemName: "record.circle")
                                .font(.caption2)
                                .apply {
                                    if #available(iOS 18.0, *) {
                                        $0.symbolEffect(.pulse .byLayer, options: .repeat(.continuous))
                                    } else {
                                        $0
                                    }
                                }
                            Text("Ongoing")
                        }
                        .foregroundStyle(.green)
                    } else if event.relativeTimeDate.isEventOver {
                        HStack {
                            Image(systemName: "clock")
                                .font(.caption2)
                            Text("Session Over")
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

func repetitionString(_ reps: [String]) -> String {
    var toreturn: [String] = []
    if reps.contains("su") {
        toreturn.append("Sunday")
    }
    if reps.contains("mo") {
        toreturn.append("Monday")
    }
    if reps.contains("tu") {
        toreturn.append("Tuesday")
    }
    if reps.contains("we") {
        toreturn.append("Wednesday")
    }
    if reps.contains("th") {
        toreturn.append( "Thursday")
    }
    if reps.contains("fr") {
        toreturn.append("Friday")
    }
    if reps.contains("sa") {
        toreturn.append("Saturday")
    }
    
    return toreturn.joined(separator: ", ")
}

#Preview {
    ContentView()
}
