//
//  SymbolImage.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2025-01-11.
//

import SwiftUI

struct SymbolImage: View {
    var symbolName: String
    init(_ symbolName: String) {
        self.symbolName = symbolName
    }
    var body: some View {
        if let _ = UIImage(named: symbolName) {
            Image(symbolName)
        } else {
            Image(systemName: symbolName)
        }
    }
}

let bipocColors: [Color] = [
    Color(red: 120/255, green: 77/255, blue: 59/255),   // <--- START; dark
    Color(red: 167/255, green: 104/255, blue: 75/255), // mid dark
    Color(red: 188/255, green: 135/255, blue: 83/255), // mid
    Color(red: 231/255, green: 196/255, blue: 182/255), // mid light light
    Color(red: 120/255, green: 77/255, blue: 59/255),   // dark
    Color(red: 120/255, green: 77/255, blue: 59/255),   // dark
]

#Preview {
    SymbolImage("tv")
}
