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

extension ItemViewModel {
    /// Returns a fake object with all available fields. For unit tests and SwiftUI previews
    static func getFakeItem() -> ItemViewModel {
        return ItemViewModel(image: "https://img-prd-pim.poorvika.com/prodvarval/Apple-iphone-16-pro-black-titanium-128gb-Front-Back-View-Thumbnail.png", itemTitle: "iPhone 16 Pro 512 GB noir batterie neuve", itemCategory: "Multimédia", itemPrice: 1200, isUrgent: true, itemDescription: "iPhone 16 Pro couleur noir, 512 GB, batterie neuve.", itemAddedDate: "2025-05-18T20:13:31+0000")
    }
    
    static func getFakeItems() -> [ItemViewModel] {
        return [
            ItemViewModel(image: "https://img-prd-pim.poorvika.com/prodvarval/Apple-iphone-16-pro-black-titanium-128gb-Front-Back-View-Thumbnail.png", itemTitle: "iPhone 16 Pro 512 GB noir batterie neuve", itemCategory: "Multimédia", itemPrice: 1200, isUrgent: true, itemDescription: "iPhone 16 Pro couleur noir, 512 GB, batterie neuve.", itemAddedDate: "2025-05-18T20:13:31+0000"),
            ItemViewModel(image: "https://encrypted-tbn1.gstatic.com/shopping?q=tbn:ANd9GcQe8p5q6MaZgbww-KSw3mAHIXkcPTRaeJC8y6G8QS6ypX88cKrqOhyxpn1qCyE8iMmolo6UnDXgSKBqnlO9LLxkBCP26ZkSzzph_cofqFTpkf3yMtPnUWh54w0P6-phPtV4Q_wHOg&usqp=CAc", itemTitle: "iPhone 16 Pro Max 256 GB sable neuf", itemCategory: "Multimédia", itemPrice: 1400, isUrgent: true, itemDescription: "iPhone 16 Pro Max neuf couleur sable, 256 GB, batterie neuve, non déballé dans sa boîte d'origine, facture Apple officielle incluse.", itemAddedDate: "2025-05-19T17:42:29+0000"),
            ItemViewModel(image: "https://www.peugeottalk.de/cms/images/avatars/7c/3752-7cfd12ec9a0125062609ecb2bae5fce78847ae7d.png", itemTitle: "Peugeot 208 GT", itemCategory: "Véhicule", itemPrice: 21000, isUrgent: false, itemDescription: "Peugeot 208 GT année 2025 bleue toutes options.", itemAddedDate: "2025-05-22T11:17:45+0000"),
            ItemViewModel(image: "https://cf.bstatic.com/xdata/images/hotel/max1024x768/258858602.jpg?k=85821b7952d70a6569617ba2ad412b3566b5d4d4dcf2c0a0e71a2d4d7042f0b5&o=&hp=1", itemTitle: "Appartement duplex Paris 15ème Convention", itemCategory: "Multimédia", itemPrice: 2300000, isUrgent: false, itemDescription: "Appartement 5 pièces en duplex situé dans Paris 15ème, rue de la Convention. Superficie de 175 m2, avec grande terrasse dotée d'une vue imprenable sur Paris.", itemAddedDate: "2025-05-18T20:13:31+0000"),
            ItemViewModel(image: "https://m.media-amazon.com/images/I/61I9PKPrrpL._AC_UF894,1000_QL80_.jpg", itemTitle: "Pot de crème de noisettes grillées El Mordjene 750g", itemCategory: "Alimentation", itemPrice: 15, isUrgent: false, itemDescription: "Pot de crème de noisettes grillées El Mordjene 750g de la marque CEBON, goût Kinder Bueno.", itemAddedDate: "2025-05-18T20:13:31+0000")
            ]
    }
}
