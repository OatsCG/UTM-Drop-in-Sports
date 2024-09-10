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
    @State var showNetworkAlert: Bool = false
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                if categoryParser.isUpdating {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack {
                                ProgressView()
                                if showNetworkAlert {
                                    Text("Check your network connection to download the schedule. You only need to do this once.")
                                        .multilineTextAlignment(.center)
                                        .font(.caption2)
                                }
                            }
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
        .onAppear {
            Task {
                try? await Task.sleep(for: .seconds(5))
                await MainActor.run {
                    if (categoryParser.isUpdating) {
                        withAnimation {
                            showNetworkAlert = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
