//
//  EventImage.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import SwiftUI

struct EventImage: View {
    var event: Event
    // if image exists, height is always 674px
    
    var body: some View {
        if let img = URL(string: event.image) {
            AsyncImage(
                url: img,
                content: { image in
                    image
                        .resizable()
                        .frame(height: 100)
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    ProgressView()
                        .frame(height: 150)
                }
            )
            .ignoresSafeArea()
        }
    }
}


#Preview {
    ContentView()
}
