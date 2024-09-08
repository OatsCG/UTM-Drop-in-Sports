//
//  EventImage.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import SwiftUI

struct EventImage: View {
    @State var img: URL = URL(string: "https://calsaas-production.s3.amazonaws.com/uploads/sites/78972/2024/08/dropin-sports-25.png")!
    var body: some View {
        AsyncImage(
            url: img,
            content: { image in
                image.resizable()
                     .aspectRatio(contentMode: .fit)
                     .ignoresSafeArea()
                     
            },
            placeholder: {
                ProgressView()
            }
        )
    }
}

#Preview {
    EventImage()
}
