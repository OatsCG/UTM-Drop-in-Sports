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
                SymbolImage(category.symbol)
                    .apply {
                        if #available(iOS 17.0, *) {
                            $0.symbolEffect(.bounce, value: category.selected)
                        } else {
                            $0
                        }
                    }
                Text(CategoryToDisplayRepresentation(category.title))
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
                    Capsule(style: .circular)
                        .strokeBorder(.quaternary, lineWidth: (colorScheme == .dark && !category.selected) ? 1 : 2)
                        .background(Capsule(style: .circular).fill(category.selected ? .primaryUTM : (colorScheme == .dark ? .white.opacity(0.05) : .white)))
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}

