//
//  ItemCategoryViewModel.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 04/06/2025.
//

struct ItemCategoryViewModel: Sendable {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension ItemCategoryViewModel {
    static func getFakeItemCategory() -> ItemCategoryViewModel {
        return ItemCategoryViewModel(id: 1, name: "Alimentaire")
    }
}
