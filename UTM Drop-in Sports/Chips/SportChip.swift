//
//  SportChip.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct SportChip: View {
    var title: String
    var image: String
    @State var favourited: Bool = false
    @State var selected: Bool = false
    var body: some View {
        Button(action: {
            withAnimation(.interactiveSpring) {
                selected.toggle()
            }
        }) {
            HStack {
                Image(systemName: image)
                    .symbolEffect(.bounce, value: selected)
                Text(title)
                    .fixedSize(horizontal: false, vertical: true)
                if favourited {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                }
            }
                .foregroundStyle(selected ? .white : .black)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background {
                    Capsule().fill(selected ? .blue : .white)
                        .stroke(.quaternary, lineWidth: 2)
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SportChip(title: "Soccer", image: "soccerball")
}
