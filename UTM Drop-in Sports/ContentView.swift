//
//  ContentView.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct ContentView: View {
    @State var categoryParser: CategoryParser = CategoryParser()
    @State var path: NavigationPath = NavigationPath()
    @State var searchField: String = ""
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                SportChips(categoryParser: $categoryParser)
                    .padding(.vertical, 10)
                EventList(categoryParser: $categoryParser)
            }
            .safeAreaPadding(.horizontal)
//            .padding(.top)
//                .safeAreaInset(edge: .top, spacing: 0) {
//                    Color.clear.frame(height: 0) // Ensures content starts below the status bar
//                }
        }
        .searchable(text: $searchField)
        .onChange(of: searchField) { _, _ in
            categoryParser.searchField = searchField
            categoryParser.updateDisplayEvents()
        }
    }
}

#Preview {
    ContentView()
}
