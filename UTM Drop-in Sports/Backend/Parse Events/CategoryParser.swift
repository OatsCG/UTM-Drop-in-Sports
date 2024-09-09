//
//  File.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import Foundation
import SwiftUI

@Observable
class CategoryParser {
    var categories: [Category] = []
    
    init() {
        Task {
            let categories = loadSortCategories()
            if let categories = categories {
                await MainActor.run {
                    self.categories = categories.categories
                }
            }
        }
    }
}
