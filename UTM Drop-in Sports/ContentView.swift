//
//  ContentView.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct ContentView: View {
    @State var path: NavigationPath = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                SportChips()
                    .padding(.vertical, 10)
                EventList()
            }
            .safeAreaPadding()
        }
    }
}

#Preview {
    ContentView()
}
