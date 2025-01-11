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

#Preview {
    SymbolImage("tv")
}
