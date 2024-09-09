//
//  SportChips.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct SportChips: View {
    @State var categoryParser: CategoryParser = CategoryParser()
    @State var organizedCategories: [[Category]] = []
    @State var width: CGFloat = 100
    @State var maxRows: Int = 3
    @State var maxWidth: CGFloat = 300
    var body: some View {
        ZStack {
            VStack {
                FlexView(data: $categoryParser.categories, maxRows: $maxRows) { category in
                    SportChip(category: category)
                }
                .padding(.bottom, 2)
                HStack {
                    Button(action: {
                        if maxRows == 3 {
                            withAnimation {
                                maxRows = .max
                            }
                        } else {
                            withAnimation {
                                maxRows = 3
                            }
                        }
                    }) {
                        Text(maxRows == 3 ? "Show More..." : "Show Less...")
                            .font(.footnote)
                    }
                    Spacer()
                }
            }
//            GeometryReader { geo in
//                HStack {
//                    Spacer()
//                    Color.clear
//                    Spacer()
//                }
//                .onChange(of: geo.size) {
//                    self.maxWidth = geo.size.width
//                }
//            }
        }
    }
}

#Preview {
    ScrollView {
        SportChips()
    }
}
