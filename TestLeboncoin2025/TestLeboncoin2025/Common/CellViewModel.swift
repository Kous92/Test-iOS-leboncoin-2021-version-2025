//
//  CellViewModel.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 18/06/2025.
//

struct CellViewModel: Sendable {
    let smallImage: String
    let itemTitle: String
    let itemCategoryId: Int
    let itemCategoryName: String
    let itemPrice: Int
    let isUrgent: Bool
    
    init(smallImage: String = "", itemTitle: String = "Titre indisponible", itemCategoryId: Int = 0, itemCategoryName: String = "Inconnu", itemPrice: Int = 0, isUrgent: Bool = false) {
        self.smallImage = smallImage
        self.itemTitle = itemTitle
        self.itemCategoryName = itemCategoryName
        self.itemCategoryId = itemCategoryId
        self.itemPrice = itemPrice
        self.isUrgent = isUrgent
    }
    
    /*
    init(with itemViewModel: ItemViewModel, and categoryName: String) {
        self.smallImage = itemViewModel.smallImage
        self.itemTitle = itemViewModel.itemTitle
        self.itemCategoryName = categoryName
        self.itemPrice = itemViewModel.itemPrice
        self.isUrgent = itemViewModel.isUrgent
    }
     */
}
