//
//  SportChip.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct SportChip: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var categoryParser: CategoryParser
    var category: Category
    @State var favourited: Bool = false
    var body: some View {
        Button(action: {
            withAnimation(.interactiveSpring) {
                category.selected.toggle()
            }
            categoryParser.updateDisplayEvents(maxEvents: 50)
        }) {
            HStack {
                if #available(iOS 17.0, *) {
                    Image(systemName: category.symbol)
                        .symbolEffect(.bounce, value: category.selected)
                } else {
                    Image(category.symbol)
                }
                Text(category.title)
                    .fixedSize(horizontal: false, vertical: true)
                if favourited {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                }
            }
                .foregroundStyle(category.selected ? .white : (colorScheme == .dark ? .white : .black))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background {
                    if colorScheme == .dark {
                        if category.selected {
                            Capsule(style: .circular)
                                .strokeBorder(.quaternary, lineWidth: 2)
                                .background(Capsule(style: .circular).fill(.primaryUTM))
                        } else {
                            Capsule(style: .circular)
                                .strokeBorder(.quaternary, lineWidth: 1)
                                .background(Capsule(style: .circular).fill(.white.opacity(0.05)))
                        }
                    } else {
                        if category.selected {
                            Capsule(style: .circular)
                                .strokeBorder(.quaternary, lineWidth: 2)
                                .background(Capsule(style: .circular).fill(.primaryUTM))
                        } else {
                            Capsule(style: .circular)
                                .strokeBorder(.quaternary, lineWidth: 2)
                                .background(Capsule(style: .circular).fill(.white))
                        }
                    }
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}

