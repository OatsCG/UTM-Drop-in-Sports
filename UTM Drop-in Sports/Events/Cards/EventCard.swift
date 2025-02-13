//
//  EventCard.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct EventCard: View {
    @Binding var event: Event
    @State var showingSheet: Bool = false
    @Namespace var animation
    var body: some View {
        Button(action: {
            showingSheet = true
        }) {
            EventCardContent(event: $event)
                .apply {
                    if #available(iOS 18.0, *) {
                        $0.matchedTransitionSource(id: event.id, in: animation)
                    } else {
                        $0
                    }
                }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingSheet) {
            EventContent(showingSheet: $showingSheet, event: $event)
                .apply {
                    if #available(iOS 18.0, *) {
                        $0.navigationTransition(.zoom(sourceID: event.id, in: animation))
                    } else {
                        $0
                    }
                }
        }
    }
}

@available(iOS 16.0, *)
struct EventCardSiri: View {
    var event: Event
    var body: some View {
        EventCardContentSiri(event: event)
    }
}

@available(iOS 16.0, *)
struct EventCardContentSiri: View {
    @Environment(\.colorScheme) private var colorScheme
    var event: Event
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                if event.lgbt {
                    SymbolImage(event.symbol)
                        .font(.title)
                        .foregroundStyle(AngularGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red], center: .center))
                        .overlay {
                            SymbolImage(event.symbol)
                                .font(.title)
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                                .opacity(colorScheme == .dark ? 0.25 : 0.15)
                            
                        }
                } else {
                    SymbolImage(event.symbol)
                        .font(.title)
                        .foregroundStyle(event.womens ? .pinkUTM : .blueUTM)
                }
                Text(event.title)
                    .font(.title3 .bold())
                    .foregroundStyle(.blueUTM)
                Spacer()
            }
            .padding(.bottom, 6)
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
                            if #available(iOS 18.0, *) {
                                Image(systemName: event.relativeTimeDate.daySymbol)
                                    .foregroundStyle(event.relativeTimeDate.daySymbolColor.mix(with: .primary, by: 0.1))
                            } else {
                                if #available(iOS 16.0, *) {
                                    Image(systemName: event.relativeTimeDate.daySymbol)
                                        .foregroundStyle(event.relativeTimeDate.daySymbolColor.gradient)
                                } else {
                                    Image(systemName: event.relativeTimeDate.daySymbol)
                                        .foregroundStyle(event.relativeTimeDate.daySymbolColor)
                                }
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
        .background(.regularMaterial)
        .contentShape(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous))
        .clipShape(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous))
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var nm = NotificationManager()
    @Previewable @State var c = CategoryParser()
    return ContentView()
        .environmentObject(c)
        .environmentObject(nm)
}
