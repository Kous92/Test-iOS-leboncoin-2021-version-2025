//
//  ItemCategoryDTO.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 04/06/2025.
//

struct ItemCategoryDTO: Sendable {
    let id: Int
    let name: String
    
    init(with itemCategory: ItemCategory) {
        self.id = itemCategory.id
        self.name = itemCategory.name
    }
}

extension ItemCategoryDTO {
    static func getFakeObjectFromItemCategory() -> ItemCategoryDTO {
        return ItemCategoryDTO(with: ItemCategory.getFakeItemCategory())
    }
}
