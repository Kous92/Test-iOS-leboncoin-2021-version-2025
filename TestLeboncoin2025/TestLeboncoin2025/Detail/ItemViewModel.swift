//
//  ItemViewModel.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 15/05/2025.
//

struct ItemViewModel {
    let image: String
    let itemTitle: String
    let itemCategory: String
    let itemPrice: Int
    let isUrgent: Bool
    let itemDescription: String
    var itemAddedDate: String
    let siret: String?
    
    init(image: String = "?", itemTitle: String = "?", itemCategory: String = "?", itemPrice: Int = 0, isUrgent: Bool = false, itemDescription: String = "?", itemAddedDate: String = "?", siret: String? = nil) {
        self.image = image
        self.itemTitle = itemTitle
        self.itemCategory = itemCategory
        self.itemPrice = itemPrice
        self.isUrgent = isUrgent
        self.itemDescription = itemDescription
        self.itemAddedDate = itemAddedDate
        self.siret = siret
    }
}
