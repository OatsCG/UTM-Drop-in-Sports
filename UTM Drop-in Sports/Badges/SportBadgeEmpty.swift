//
//  SportBadgeEmpty.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-10-07.
//

import SwiftUI


struct SportMedalEmpty: View {
    @Binding var size: CGFloat
    var medal: Medal
    @State var showingSheet: Bool = false
    @Namespace var animation
    var body: some View {
        Circle()
            .strokeBorder(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .miter, miterLimit: 0, dash: [((size - 5) * CGFloat.pi / 20)], dashPhase: 0))
            .foregroundColor(.primary.opacity(0.2))
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(.primary.opacity(0.1))
                    .frame(width: size, height: size)
            )
            .overlay {
                SportMedalSymbol(size: $size, symbol: ImageResource(name: medal.icon, bundle: .main))
                    .foregroundStyle(.tertiary)
            }
    }
}

struct SportMedallionEmptyDisplay: View {
    @Binding var size: CGFloat
    var medal: Medal
    @State var showingSheet: Bool = false
    @Namespace var animation
    var body: some View {
        Button(action: {
            showingSheet.toggle()
        }) {
            if #available(iOS 18.0, *) {
                VStack(alignment: .center) {
                    SportMedalEmpty(size: $size, medal: medal)
                    Text(medal.category)
                        .font(.body .bold())
                }
                .matchedTransitionSource(id: medal.id, in: animation)
            } else {
                VStack(alignment: .center) {
                    SportMedalEmpty(size: $size, medal: medal)
                    Text(medal.category)
                        .font(.body .bold())
                }
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingSheet) {
            if #available(iOS 18.0, *) {
                SportMedalSheet(medal: medal, colorPrimary: medal.colorPrimary, colorSecondary: medal.colorSecondary)
                    .navigationTransition(.zoom(sourceID: medal.id, in: animation))
            } else {
                SportMedalSheet(medal: medal, colorPrimary: medal.colorPrimary, colorSecondary: medal.colorSecondary)
            }
        }
    }
}


#Preview {
    SportMedalEmpty(size: .constant(300), medal: .init(category: "Soccer", icon: "soccerball", possibleEvents: []))
}
