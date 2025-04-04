//
//  EventBody.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import SwiftUI

struct EventBody: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var categoryParser: CategoryParser
    @EnvironmentObject var notificationManager: NotificationManager
    var event: Event
    var body: some View {
        VStack(alignment: .leading) {
            if event.description != "" {
                Text(event.description)
                    .padding(.bottom, 16)
            }
            VStack(alignment: .leading) {
                if event.womens {
                    HStack(alignment: .top) {
                        Image("figure.stand.dress")
                            .foregroundStyle(.pinkUTM)
                        Text("This is a **Women's Only** session")
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.secondary)
                    }
                        .font(.footnote)
                }
                if event.lgbt {
                    HStack(alignment: .top) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(AngularGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red], center: .center))
                            .overlay {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    .opacity(colorScheme == .dark ? 0.25 : 0.15)
                                
                            }
                        Text("This is a **Pride Sports** session")
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.secondary)
                    }
                        .font(.footnote)
                }
                if event.bipoc {
                    HStack(alignment: .top) {
                        Image(systemName: "hand.raised")
                            .foregroundStyle(AngularGradient(colors: bipocColors, center: .center))
                            .overlay {
                                Image(systemName: "hand.raised")
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    .opacity(colorScheme == .dark ? 0.25 : 0.15)
                                
                            }
                        Text("This is a **BIPOC Sports** session")
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.secondary)
                    }
                        .font(.footnote)
                }
                if event.weeklyRepetitions.count > 0 {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .font(.footnote .bold())
                        Text("Repeats every \(repetitionString(event.weeklyRepetitions))")
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
            }
            .padding(.bottom, 10)
        }
        
        // PUT HSTACK HERE
        HStack {
            if let url = URL(string: event.url) {
                Link(destination: url) {
                    Text("Open \(Image(systemName: "arrow.up.right.square"))")
                }
            }
            Spacer()
            if let url = URL(string: event.ticket_url) {
                Link(destination: url) {
                    Text(event.ticket_label)
                }
            }
        }
        .padding(.bottom, 25)
        
        if event.saved {
            Button(action: {
                categoryParser.unsaveEvent(event: event)
                notificationManager.cancelNotification(event: event)
            }) {
                VStack(alignment: .center) {
                    HStack {
                        Text("Session Saved")
                        Image(systemName: "bookmark.fill")
                    }
                    if notificationManager.currentlyScheduledEvents.contains(event.id) {
                        Text("We'll notify you 30 minutes before it starts")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Have Fun!")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(.blueUTMdark)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.bottom, 60)
        } else {
            VStack(alignment: .center) {
                Button(action: {
                    categoryParser.saveEvent(event: event)
                    notificationManager.scheduleNotification(event: event)
                }) {
                    HStack {
                        Text("Save This Session")
                        Image(systemName: "bookmark")
                    }
                        .foregroundStyle(.black)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(.blueUTMlight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.bottom, 10)
                if !categoryParser.allCategories.filter({ $0.isMedal && $0.title == event.sortCategory }).isEmpty {
                    Text("Save this session to earn a **\(CategoryToDisplayRepresentation(event.sortCategory))** medal after participating")
                        .foregroundStyle(.tertiary)
                        .font(.caption)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    VStack {
        HStack {
            Text("Save This Session")
            Image(systemName: "bookmark")
        }
            .foregroundStyle(.black)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(.blueUTMlight)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        VStack(alignment: .center) {
            HStack {
                Text("Session Saved")
                Image(systemName: "bookmark.fill")
            }
            Text("We'll notify you 30 minutes before it starts")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
            .foregroundStyle(.white)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(.blueUTMdark)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
