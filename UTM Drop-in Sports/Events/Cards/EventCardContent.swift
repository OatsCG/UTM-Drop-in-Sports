//
//  EventCardContent.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct EventCardContent: View {
    @Binding var event: Event
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                if #available (iOS 17.0, *) {
                    Image(systemName: event.symbol)
                        .font(.title)
                        .foregroundStyle(event.womens ? .pinkUTM : .blueUTM)
                } else {
                    Image(event.symbol)
                        .font(.title)
                        .foregroundStyle(event.womens ? .pinkUTM : .blueUTM)
                }
                Text(event.title)
                    .font(.title3 .bold())
                    .foregroundStyle(.blueUTM)
                Spacer()
                if event.saved {
                    Image(systemName: "bookmark.fill")
                        .font(.title2)
                        .foregroundStyle(.blueUTM)
                }
            }
            
            .padding(.bottom, 6)
            Spacer()
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
        .background {
            if #available(iOS 17.0, *) {
                if event.saved && event.relativeTimeDate.isOngoing {
                    RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous)
                        .fill(
                            .blueUTMbg.gradient.opacity(0.3)
                        )
                        .stroke(.tertiary, lineWidth: 2)
                } else {
                    RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous)
                        .fill(.white.opacity(0.05))
                        .stroke(.tertiary, lineWidth: 2)
                }
            } else {
                if event.saved && event.relativeTimeDate.isOngoing {
                    RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous)
                        .strokeBorder(.tertiary, lineWidth: 2)
                        .background(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous).fill(.blueUTMbg.opacity(0.3)))
                } else {
                    RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous)
                        .strokeBorder(.tertiary, lineWidth: 2)
                        .background(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous).fill(.white.opacity(0.05)))
                }
            }
        }
        .contentShape(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous))
        .clipShape(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous))
    }
}

//#Preview {
//    @State var c = CategoryParser()
//    return ContentView()
//        .environmentObject(c)
//}
