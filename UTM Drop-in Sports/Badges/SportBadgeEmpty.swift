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
            .strokeBorder(style: StrokeStyle(lineWidth: (size * 0.03), lineCap: .round, lineJoin: .miter, miterLimit: 0, dash: [((size - (size * 0.03)) * CGFloat.pi / 20)], dashPhase: 0))
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
    @Environment(\.colorScheme) private var colorScheme
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
                    ZStack {
                        SportMedalEmpty(size: $size, medal: medal)
                            .padding(.bottom, 10)
                            .background(alignment: .bottom) {
                                VStack(spacing: 0) {
                                    Trapezoid(topWidthRatio: 0.7)
                                        .stroke(.primary.opacity(0.2), lineWidth: 1)
                                        .fill(LinearGradient(gradient: Gradient(colors: [.primary.opacity(0.08), .primary.opacity(0.38)]), startPoint: .top, endPoint: .bottom))
                                        .frame(height: 14)
                                    Rectangle()
                                        .stroke(.primary.opacity(0.2), lineWidth: 1)
                                        .fill(.primary.opacity(0.4))
                                        .frame(height: 5)
                                }
                                .opacity(colorScheme == .dark ? 1 : 0.5)
                            }
                    }
                    Text(medal.category)
                        .font(.body .bold())
                }
                .matchedTransitionSource(id: medal.category, in: animation)
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
                SportMedalSheet(medal: medal, colorPrimary: medal.colorPrimary, colorSecondary: medal.colorSecondary, showingSheet: $showingSheet)
                    .navigationTransition(.zoom(sourceID: medal.category, in: animation))
            } else {
                SportMedalSheet(medal: medal, colorPrimary: medal.colorPrimary, colorSecondary: medal.colorSecondary, showingSheet: $showingSheet)
            }
        }
    }
}


#Preview {
    SportMedalEmpty(size: .constant(300), medal: .init(category: "Soccer", icon: "soccerball", possibleEvents: []))
}
