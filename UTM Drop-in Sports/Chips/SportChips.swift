//
//  SportChips.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-05.
//

import SwiftUI

struct SportChips: View {
    var body: some View {
        VStack {
            ForEach(0..<3) { index in
                HStack {
                    ForEach(0..<2) { index in
                        SportChip(title: generateRandomString(), image: "soccerball")
                        
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        SportChips()
    }
}

func generateRandomString() -> String {
    let options: [String] = ["Soccer", "Basketball", "Tennis", "Golf", "Swimming", "Baseball", "Hockey", "Lacrosse", "Volleyball", "Water Polo", "Biking", "Running", "Skating", "Cycling", "Swimming", "Basketball", "Tennis", "Golf", "Swimming", "Baseball", "Hockey", "Lacrosse", "Volleyball", "Water Polo", "Biking", "Running", "Skating", "Cycling"]
    return options.randomElement()!
}
