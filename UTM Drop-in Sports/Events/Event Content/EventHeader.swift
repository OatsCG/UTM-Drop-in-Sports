//
//  EventHeader.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import SwiftUI

struct EventHeader: View {
    var body: some View {
        HStack(alignment: .center) {
            // soccerball of color #11264b
            Image(systemName: "soccerball")
                .font(.largeTitle)
            Text("Drop-in Soccer")
                .font(.title .bold())
            Spacer()
        }
        .foregroundStyle(Color(red: 0.06666666666666667, green: 0.14901960784313725, blue: 0.29411764705882354))
        //.foregroundStyle(Color(hue: 0.67, saturation: 0.05, brightness: 1.0))
        
        .padding(.bottom, 10)
        VStack {
            HStack {
                HStack {
                    Image(systemName: "mappin")
                        .symbolRenderingMode(.hierarchical)
                    Text("Gym A/B")
                }
                Spacer()
            }
            .font(.subheadline .bold())
            .padding(.bottom, 2)
            HStack {
                Image(systemName: "clock")
                    .symbolRenderingMode(.hierarchical)
                Text("9:00am - 10:00am")
                Spacer()
                Image(systemName: "calendar")
                    .foregroundStyle(.secondary)
                Text("Tuesday Sept 2")
                    .foregroundStyle(.secondary)
            }
            .font(.footnote)
            .foregroundStyle(.primary)
            
        }
        .padding(.leading, 10)
    }
}

#Preview {
    EventHeader()
}
