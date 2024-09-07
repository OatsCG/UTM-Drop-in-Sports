//
//  EventCardContent.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct EventCardContent: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image(systemName: "soccerball")
                    .font(.title)
                Text("Drop-in Soccer")
                    .font(.title3 .bold())
                Spacer()
            }
            //.foregroundStyle(Color(red: 0.06666666666666667, green: 0.14901960784313725, blue: 0.29411764705882354))
            .foregroundStyle(Color(hue: 0.6055555556, saturation: 0.63, brightness: 0.15))
            Spacer()
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
        .padding(15)
        .background {
            RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous).fill(.clear)
                .stroke(.tertiary, lineWidth: 2)
        }
        .contentShape(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous))
        .clipShape(RoundedRectangle(cornerSize: .init(width: 15, height: 15), style: .continuous))
        .frame(height: 120)
    }
}

#Preview {
    ContentView()
}
