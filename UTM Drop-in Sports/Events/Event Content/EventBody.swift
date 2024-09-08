//
//  EventBody.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import SwiftUI

struct EventBody: View {
    var body: some View {
        Text("Body description of event, which is super long and will wrap to multiple lines if needed (this is a test) and will be truncated to 100 characters if it is longer than that (this is a test) and will be truncated to 100 characters if it is longer than that (this is a test) and will be truncated to 100 characters if it is longer than that (this is a test) and will be truncated to 100 characters if it is longer than that (this is a test) and will be truncated to 100 characters if it is longer than that (this is a test) and will be truncated to 100 characters if it.")
            .padding(.bottom, 30)
        
        HStack {
            Button(action: {
                
            }) {
                // UTM Event Website
                Text("UTM Event Website")
            }
            Spacer()
            Button(action: {
                
            }) {
                // Event Admission status (none, book now, reserve your spot)
                Text("Book now!")
            }
        }
    }
}

#Preview {
    EventBody()
}
