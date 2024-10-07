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
        Text(event.description)
            .padding(.bottom, 10)
        
        if notificationManager.currentlyScheduledEvents.contains(event.id) {
            Button(action: {
                categoryParser.saveEvent(event: event)
                notificationManager.cancelNotification(event: event)
            }) {
                VStack(alignment: .center) {
                    HStack {
                        Text("Event Saved")
                        Image(systemName: "bookmark.fill")
                    }
                    Text("We'll notify you 30 minutes before it starts")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
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
                notificationManager.scheduleNotification(event: event)
            }) {
                HStack {
                    Text("Save This Event")
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
                    Text("UTM Event Website")
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
            Text("Save This Event")
            Image(systemName: "bookmark")
        }
            .foregroundStyle(.black)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(.blueUTMlight)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        VStack(alignment: .center) {
            HStack {
                Text("Event Saved")
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
