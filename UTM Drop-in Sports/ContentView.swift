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
            categoryParser.updateDisplayEvents(maxDays: 14)
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
            if #available(iOS 17.0, *) {
                MainScrollContentView(showNetworkAlert: $showNetworkAlert)
            } else {
                MainScrollContentView(showNetworkAlert: $showNetworkAlert)
                    .padding(.horizontal)
            }
        }
    }
}

struct MainScrollContentView: View {
    @EnvironmentObject var categoryParser: CategoryParser
    @Binding var showNetworkAlert: Bool
    var body: some View {
        if categoryParser.isUpdating {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        ProgressView()
                        if showNetworkAlert {
                            Text("Check your network connection to update the schedule.")
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
                LoadMoreEventsButton()
                    .padding(.top, 10)
                    .padding(.bottom, 30)
            }
        }
    }
}

struct LoadMoreEventsButton: View {
    @EnvironmentObject var categoryParser: CategoryParser
    var body: some View {
        HStack {
            if !categoryParser.isEventsExpandedToMax {
                Spacer()
                Button(action: {
                    categoryParser.updateDisplayEvents(maxDays: nil)
                }) {
                    Text("Load More Events...")
                }
                Spacer()
            }
        }
    }
}



//#Preview {
//    @State var c = CategoryParser()
//    return ContentView()
//        .environmentObject(c)
//}
