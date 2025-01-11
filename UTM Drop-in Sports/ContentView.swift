//
//  ContentView.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI
import AppIntents

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var categoryParser: CategoryParser
    @EnvironmentObject var notificationManager: NotificationManager
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
            categoryParser.updateDisplayEvents(maxEvents: 50)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Active")
                notificationManager.clearNotificationBadges()
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
            }
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


enum ScheduleSchool: String, CaseIterable {
    case mississauga = "Mississauga", stgeorge = "St. George", scarborough = "Scarborough"
}

@available(iOS 16.0, *)
struct MainNavigationView: View {
    @AppStorage("scheduleSchool") var scheduleSchool: String = "Mississauga"
    @State var path: NavigationPath = NavigationPath()
    @Binding var showNetworkAlert: Bool
    var body: some View {
        NavigationStack(path: $path) {
            if #available(iOS 17.0, *) {
                MainScrollView(showNetworkAlert: $showNetworkAlert)
                    .safeAreaPadding(.horizontal)
                    .navigationTitle(Text("UTM Sports"))
//                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
//                        ToolbarTitleMenu {
//                            Picker("Picker", selection: $scheduleSchool) {
//                                ForEach(ScheduleSchool.allCases, id: \.self) { school in
//                                    Text(school.rawValue)
//                                }
//                            }
//                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: DisplayCase()) {
                                Image(.medal)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
            } else {
                MainScrollView(showNetworkAlert: $showNetworkAlert)
                    .navigationTitle(Text("UTM Sports"))
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: DisplayCase()) {
                                Image(.medal)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
            }
        }
    }
}


struct DisplayCase: View {
    @State var maxRows: Int = .max
    @State var size: CGFloat = 110
    @State var showingClearAlert: Bool = false
    @State var showingClearConfirmAlert: Bool = false
    @EnvironmentObject var categoryParser: CategoryParser
    var body: some View {
        ScrollView {
            if categoryParser.medalsCollected.isEmpty {
                VStack {
                    Image(systemName: "flag.2.crossed")
                        .foregroundStyle(.secondary)
                        .imageScale(.large)
                        .font(.largeTitle)
                    Text("No medals collected.")
                        .font(.title2 .bold())
                    Text("Save events and participate to earn medals.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } else {
                FlexView(data: $categoryParser.medalsCollected, spacing: 10, alignment: .center, maxRows: $maxRows) { medal in
                    VStack {
                        Group {
                            if medal.type == .none {
                                SportMedallionEmptyDisplay(size: $size, medal: medal)
                            } else {
                                SportMedallionDisplay(size: $size, medal: medal)
                            }
                        }
                    }
                    .padding(.bottom, 10)
                }
                Text("Participate in events to earn more medals!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 15)
            }
        }
        .navigationTitle("Medals")
        .alert("Remove all medals?", isPresented: $showingClearAlert) {
            Button("Delete...", role: .destructive) {
                showingClearConfirmAlert = true
            }
            Button("Cancel", role: .cancel) {  }
        } message: {
            Text("This will clear all your progress. This cannot be undone.")
        }
        .alert("Are you sure you want to remove all progress?", isPresented: $showingClearConfirmAlert) {
            Button("Yes, Delete", role: .destructive) {
                categoryParser.clearAllMedals()
            }
            Button("No, Cancel", role: .cancel) {  }
        }

    }
}


@available(iOS 15.0, *)
struct MainNavigationViewLegacy: View {
    @Binding var showNetworkAlert: Bool
    var body: some View {
        NavigationView {
            MainScrollView(showNetworkAlert: $showNetworkAlert)
                .navigationTitle(Text("UTM Sports"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: DisplayCase()) {
                            Image(.medal)
                                .foregroundColor(.primary)
                        }
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
}


struct MainScrollView: View {
    @AppStorage("isTipVisible") var isTipVisible: Bool = true
    @EnvironmentObject var categoryParser: CategoryParser
    @Binding var showNetworkAlert: Bool
    var body: some View {
        ScrollView {
            if #available(iOS 16.0, *) {
                SiriTipView(intent: GetNextSportInfo(), isVisible: $isTipVisible)
                    .siriTipViewStyle(.automatic)
            }
            if #available(iOS 17.0, *) {
                MainScrollContentView(showNetworkAlert: $showNetworkAlert)
            } else {
                MainScrollContentView(showNetworkAlert: $showNetworkAlert)
                    .padding(.horizontal)
            }
        }
    }
}

enum ScrollPicks: String, CaseIterable {
    case pick1, pick2, pick3
}

struct MainScrollContentView: View {
    @EnvironmentObject var categoryParser: CategoryParser
    @Binding var showNetworkAlert: Bool
    @State var scrollPick: Bool = false
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
                Announcements()
                FeaturedEvents()
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
            if !categoryParser.isEventsExpandedToMax && categoryParser.events.count > 0 && categoryParser.events.count > 50 {
                Spacer()
                Button(action: {
                    categoryParser.updateDisplayEvents(maxEvents: nil)
                }) {
                    VStack {
                        Text("Load More Events...")
                        Text("Schedule Version: \(UserDefaults.standard.string(forKey: "version.txt") ?? "Unknown")")
                            .font(.caption2)
                    }
                }
                Spacer()
            }
        }
    }
}
