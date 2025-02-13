//
//  FeaturedEvents.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2025-01-11.
//

import SwiftUI

struct FeaturedEvents: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var categoryParser: CategoryParser
    @State var isExpanded: Bool = true
    
    var body: some View {
        if !categoryParser.featuredEvents.isEmpty {
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.headline)
                        Text("Featured Events")
                            .font(.headline)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .quaternary)
                            .font(.title3)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                if isExpanded {
                    FeaturedEventsList()
                }
            }
            .background {
                if colorScheme == .dark {
                    Rectangle()
                        .fill(.primary.opacity(0.085))
                } else {
                    Rectangle()
                        .fill(Color(red: 0.96, green: 0.96, blue: 0.975))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.top, 10)
            .padding(.bottom, 6)
            Divider()
                .padding(.bottom, 6)
        }
    }
}

struct FeaturedEventsList: View {
    @EnvironmentObject var categoryParser: CategoryParser
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack {
            ForEach($categoryParser.featuredEvents, id: \.id) { $event in
                EventCard(event: $event)
                    .apply {
                        if #available(iOS 17.0, *) {
                            $0.transition(.blurReplace)
                        } else {
                            $0
                        }
                    }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background {
            if colorScheme == .dark {
                Rectangle()
                    .fill(.background.opacity(0.4))
            } else {
                Rectangle()
                    .fill(.background.opacity(0.5))
            }
        }
    }
}
