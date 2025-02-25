//
//  EventCardContent.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct EventCardContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var event: Event
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
                } else if event.bipoc {
                    SymbolImage(event.symbol)
                        .font(.title)
                        .foregroundStyle(AngularGradient(colors: bipocColors, center: .center))
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
                    .lineLimit(1)
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
                            .lineLimit(1)
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
                                            $0/*.symbolEffect(.pulse .byLayer, options: .repeat(.continuous))*/
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
        .background {
            if event.saved && event.relativeTimeDate.isOngoing {
                RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous)
                    .apply {
                        if #available(iOS 17.0, *) {
                            $0
                                .fill(.blueUTMbg.gradient.opacity(0.3))
                                .stroke(.tertiary, lineWidth: 2)
                        } else {
                            $0
                                .strokeBorder(.tertiary, lineWidth: 2)
                                .background(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous).fill(.blueUTMbg.opacity(0.3)))
                        }
                    }
            } else {
                RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous)
                    .apply {
                        if #available(iOS 17.0, *) {
                            $0
                                .fill(.white.opacity(0.05))
                                .stroke(.tertiary, lineWidth: 2)
                        } else {
                            $0
                                .strokeBorder(.tertiary.opacity(0.5), lineWidth: 2)
                                .background(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous).fill(.white.opacity(0.05)))
                        }
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
