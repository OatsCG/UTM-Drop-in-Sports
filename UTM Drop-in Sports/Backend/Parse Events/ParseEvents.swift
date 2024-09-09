//
//  ParseEvents.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-08.
//

import Foundation

func loadSortCategories() -> EventJSON? {
    guard let fileURL = Bundle.main.url(forResource: "events", withExtension: "json") else {
        print("File not found: events.json")
        return nil
    }

    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(EventJSON.self, from: data)
        return decodedData
    } catch {
        print("Error reading or parsing file: \(error)")
        return nil
    }
}


class EventJSON: Decodable {
    let categories: [Category]
    let events: [Event]
}


@Observable
class Category: Decodable, Hashable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        symbol = try values.decode(String.self, forKey: .symbol)
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case symbol
    }
    
    var id: UUID = UUID()
    let title: String
    let symbol: String
    var selected: Bool = false
}

@Observable
class Event: Decodable {
    let url: String
    let title: String
    let description: String
    let image: String
    let start_date: String
    let end_date: String
    let venue: String
    let ticket_label: String
    let ticket_url: String
    let sortCategory: String
    let symbol: String
    let womens: Bool
}
