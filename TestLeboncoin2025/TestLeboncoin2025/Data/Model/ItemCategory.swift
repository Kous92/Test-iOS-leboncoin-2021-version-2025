//
//  ItemCategory.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 04/06/2025.
//

struct ItemCategory: Decodable, Sendable {
    let id: Int
    let name: String
}

extension ItemCategory {
    static func getFakeItemCategory() -> ItemCategory {
        return ItemCategory(id: 1, name: "Alimentaire")
    }
}
