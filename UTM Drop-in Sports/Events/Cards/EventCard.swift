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
            if #available(iOS 18.0, *) {
                EventCardContent(event: $event)
                    .matchedTransitionSource(id: event.id, in: animation)
            } else {
                EventCardContent(event: $event)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingSheet) {
            if #available(iOS 18.0, *) {
                EventContent(showingSheet: $showingSheet, event: $event)
                    .navigationTransition(.zoom(sourceID: event.id, in: animation))
            } else {
                EventContent(showingSheet: $showingSheet, event: $event)
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
    var event: Event
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                if #available (iOS 17.0, *) {
                    Image(systemName: event.symbol)
                        .font(.title)
                } else {
                    Image(event.symbol)
                        .font(.title)
                }
                Text(event.title)
                    .font(.title3 .bold())
                Spacer()
            }
            .foregroundStyle(.blueUTM)
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
                                    //.symbolVariant(.fill)
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
//        .background {
//            if #available(iOS 17.0, *) {
//                RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous)
//                    .fill(.white.opacity(0.05))
//                    .stroke(.tertiary, lineWidth: 2)
//            } else {
//                RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous)
//                    .strokeBorder(.tertiary, lineWidth: 2)
//                    .background(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous).fill(.white.opacity(0.05)))
//            }
//        }
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
