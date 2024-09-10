//
//  ContentView.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var categoryParser: CategoryParser
    @State var searchField: String = ""
    @State var showNetworkAlert: Bool = false
    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                MainNavigationView(showNetworkAlert: $showNetworkAlert)
            } else {
                MainNavigationViewLegacy(showNetworkAlert: $showNetworkAlert)
            }
        }
        .searchable(text: $searchField)
        .onChange(of: searchField) { _ in
            categoryParser.searchField = searchField
            categoryParser.updateDisplayEvents()
        }
        .onAppear {
            Task {
                if #available(iOS 16.0, *) {
                    try? await Task.sleep(for: .seconds(5))
                } else {
                    try? await Task.sleep(nanoseconds: 5_000_000_000)
                }
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

@available(iOS 16.0, *)
struct MainNavigationView: View {
    @State var path: NavigationPath = NavigationPath()
    @Binding var showNetworkAlert: Bool
    var body: some View {
        NavigationStack(path: $path) {
            if #available(iOS 17.0, *) {
                MainScrollView(showNetworkAlert: $showNetworkAlert)
                    .navigationTitle(Text("UTM Drop-Ins"))
                    .safeAreaPadding(.horizontal)
            } else {
                MainScrollView(showNetworkAlert: $showNetworkAlert)
                    .navigationTitle(Text("UTM Drop-Ins"))
            }
        }
    }
}

struct MainNavigationViewLegacy: View {
    @Binding var showNetworkAlert: Bool
    var body: some View {
        NavigationView {
            if #available(iOS 17.0, *) {
                MainScrollView(showNetworkAlert: $showNetworkAlert)
                    .navigationTitle(Text("UTM Drop-Ins"))
                    .safeAreaPadding(.horizontal)
            } else {
                MainScrollView(showNetworkAlert: $showNetworkAlert)
                    .navigationTitle(Text("UTM Drop-Ins"))
            }
        }
    }
}


struct MainScrollView: View {
    @EnvironmentObject var categoryParser: CategoryParser
    @Binding var showNetworkAlert: Bool
    var body: some View {
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
                    SportChips()
                        .padding(.vertical, 10)
                    EventList()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
