//
//  SportChips.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct SportChips: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var categoryParser: CategoryParser
    @State var organizedCategories: [[Category]] = []
    @State var maxRows: Int = 3
    @State var isExpanded: Bool = false
    @State var maxWidth: CGFloat = 300
    var body: some View {
        ZStack {
            VStack {
                FlexView(data: $categoryParser.categories, maxRows: $maxRows) { category in
                    SportChip(category: category)
                }
                .padding(.bottom, 2)
                if isExpanded {
                    VStack(alignment: .leading) {
                        HStack {
                            WomensOnlyButton()
                            PrideOnlyButton()
                            Spacer()
                        }
                        
                        Button(action: {
                            withAnimation(.interactiveSpring) {
                                categoryParser.onlySaved.toggle()
                            }
                            categoryParser.updateDisplayEvents(maxEvents: 50)
                        }) {
                            HStack {
                                Text("Saved")
                                if #available(iOS 17.0, *) {
                                    Image(systemName: categoryParser.onlySaved ? "bookmark.fill" : "bookmark")
                                        .contentTransition(.symbolEffect(.replace.offUp))
                                } else {
                                    Image(systemName: categoryParser.onlySaved ? "bookmark.fill" : "bookmark")
                                }
                            }
                            .foregroundStyle(categoryParser.onlySaved ? .black : (colorScheme == .dark ? .white : .black))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background {
                                if categoryParser.onlySaved {
                                    if #available(iOS 16.0, *) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(.blueUTMlight, lineWidth: 2)
                                            .background(RoundedRectangle(cornerRadius: 8).fill(.blueUTMlight.gradient))
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .strokeBorder(.blueUTMlight, lineWidth: 2)
                                            .background(RoundedRectangle(cornerRadius: 8).fill(.blueUTMlight))
                                    }
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(.blueUTMlight, lineWidth: colorScheme == .dark ? 1 : 2)
                                        .background(RoundedRectangle(cornerRadius: 8).fill(colorScheme == .dark ? .white.opacity(0.05) : .white))
                                }
                            }
                        }
                            .buttonStyle(.plain)
                    }
                }
                HStack {
                    Button(action: {
                        if maxRows == 3 {
                            withAnimation {
                                maxRows = .max
                                isExpanded = true
                            }
                        } else {
                            withAnimation {
                                maxRows = 3
                                isExpanded = false
                            }
                        }
                    }) {
                        HStack {
                            if isExpanded {
                                Text("Show Less...")
                            } else {
                                Text("Show More...")
                                ForEach(categoryParser.categories.filter({ $0.selected }), id: \.id) { category in
                                    if #available(iOS 17.0, *) {
                                        Image(systemName: category.symbol)
                                            .foregroundStyle(.blueUTM)
                                    } else {
                                        Image(category.symbol)
                                            .foregroundStyle(.blueUTM)
                                    }
                                }
                                if (categoryParser.onlyWomens) {
                                    Image("figure.stand.dress")
                                        .foregroundStyle(.pinkUTM)
                                }
                                if (categoryParser.onlyLGBT) {
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(AngularGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red], center: .center))
                                        .overlay {
                                            Image(systemName: "star.fill")
                                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                                                .opacity(colorScheme == .dark ? 0.25 : 0.15)
                                            
                                        }
                                }
                                if (categoryParser.onlySaved) {
                                    Image(systemName: "bookmark.fill")
                                        .foregroundStyle(.blueUTM)
                                }
                            }
                        }
                            .font(.footnote)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct WomensOnlyButton: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var categoryParser: CategoryParser
    var body: some View {
        Button(action: {
            withAnimation(.interactiveSpring) {
                categoryParser.onlyWomens.toggle()
            }
            categoryParser.updateDisplayEvents(maxEvents: 50)
        }) {
            HStack {
                Text("Women's Only")
                if #available(iOS 17.0, *) {
                    Image(systemName: categoryParser.onlyWomens ? "checkmark.square" : "square")
                        .contentTransition(.symbolEffect(.replace.offUp))
                } else {
                    Image(systemName: categoryParser.onlyWomens ? "checkmark.square" : "square")
                }
            }
            .foregroundStyle(categoryParser.onlyWomens ? .black : (colorScheme == .dark ? .white : .black))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background {
                if categoryParser.onlyWomens {
                    if #available(iOS 16.0, *) {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(.pinkUTMlight, lineWidth: 2)
                            .background(RoundedRectangle(cornerRadius: 8).fill(.pinkUTMlight.gradient))
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(.pinkUTMlight, lineWidth: 2)
                            .background(RoundedRectangle(cornerRadius: 8).fill(.pinkUTMlight))
                    }
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.pinkUTMlight, lineWidth: colorScheme == .dark ? 1 : 2)
                        .background(RoundedRectangle(cornerRadius: 8).fill(colorScheme == .dark ? .white.opacity(0.05) : .white))
                }
            }
        }
            .buttonStyle(.plain)
    }
}

struct PrideOnlyButton: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var categoryParser: CategoryParser
    var body: some View {
        Button(action: {
            withAnimation(.interactiveSpring) {
                categoryParser.onlyLGBT.toggle()
            }
            categoryParser.updateDisplayEvents(maxEvents: 50)
        }) {
            HStack {
                Text("LGBT+ Only")
                if #available(iOS 17.0, *) {
                    Image(systemName: categoryParser.onlyLGBT ? "checkmark.square" : "square")
                        .contentTransition(.symbolEffect(.replace.offUp))
                } else {
                    Image(systemName: categoryParser.onlyLGBT ? "checkmark.square" : "square")
                }
            }
            .foregroundStyle(categoryParser.onlyLGBT ? .black : (colorScheme == .dark ? .white : .black))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background {
                if categoryParser.onlyLGBT {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(AngularGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red], center: .center), lineWidth: 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AngularGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red], center: .center))
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.white)
                                .opacity(colorScheme == .dark ? 0.4 : 0.65)
                        }
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(AngularGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red], center: .center), lineWidth: colorScheme == .dark ? 1 : 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(colorScheme == .dark ? .white.opacity(0.05) : .white)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(.white, lineWidth: colorScheme == .dark ? 1 : 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.clear)
                                )
                                .opacity(colorScheme == .dark ? 0.3 : 0.6)
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
