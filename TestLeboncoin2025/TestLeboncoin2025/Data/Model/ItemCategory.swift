//
//  ItemCategory.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 04/06/2025.
//

// Codable car nécessaire pour la mise en cache
struct ItemCategory: Codable, Sendable {
    let id: Int
    let name: String
}

extension ItemCategory {
    static func getFakeItemCategory() -> ItemCategory {
        return ItemCategory(id: 1, name: "Alimentaire")
    }
}
