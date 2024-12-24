//
//  EventBody.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import SwiftUI

struct EventBody: View {
    @EnvironmentObject var categoryParser: CategoryParser
    @EnvironmentObject var notificationManager: NotificationManager
    var event: Event
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.description)
                .padding(.bottom, 10)
            if event.womens {
                HStack(alignment: .top) {
                    Image("figure.stand.dress")
                        .foregroundStyle(.pinkUTM)
                    Text("This session is reserved for female-identifying students only.")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.secondary)
                }
                    .font(.footnote)
                    .padding(.bottom, 10)
            }
        }
        
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
            .padding(.bottom, 30)
        } else {
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
            .padding(.bottom, 30)
        }
        
        
        HStack {
            if let url = URL(string: event.url) {
                Link(destination: url) {
                    Text("View Session in Browser")
                }
            }
            Spacer()
            if let url = URL(string: event.ticket_url) {
                Link(destination: url) {
                    Text(event.ticket_label)
                }
            }
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
