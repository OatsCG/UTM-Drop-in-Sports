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
                if categoryParser.isUpdating {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        Spacer()
                    }
                } else {
                    VStack {
                        SportChips(categoryParser: $categoryParser)
                            .padding(.vertical, 10)
                        EventList(categoryParser: $categoryParser)
                    }
                }
            }
            .safeAreaPadding(.horizontal)
            .navigationTitle(Text("UTM Drop-Ins"))
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
