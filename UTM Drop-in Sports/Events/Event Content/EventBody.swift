//
//  EventBody.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import SwiftUI

struct EventBody: View {
    var event: Event
    var body: some View {
        Text(event.description)
            .padding(.bottom, 30)
        
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
