//
//  Item.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 04/06/2025.
//

struct Item: Decodable, Sendable {
    let id, categoryID: Int
    let title, description: String
    let price: Int
    let imagesURL: ImagesURL
    let creationDate: String
    let isUrgent: Bool
    let siret: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case title, description, price
        case imagesURL = "images_url"
        case creationDate = "creation_date"
        case isUrgent = "is_urgent"
        case siret
    }
}

// MARK: - ImagesURL
struct ImagesURL: Decodable, Sendable {
    let small, thumb: String?
}

extension Item {
    static func getFakeItem() -> Item {
        return Item(
            id: 1,
            categoryID: 1,
            title: "McLaren F1",
            description: "McLaren F1 châssis 052/069, moteur V12 BMW 6,1 litres 627 chevaux.",
            price: 20000000,
            imagesURL: ImagesURL(small: "https://www.robot-forum.com/images/avatars/f1/13688-f1f6a41d04cf0524a9c6e2147a829aeb241c05b5.jpg", thumb: "https://pistonaddict.com/wp-content/uploads/2022/05/mclaren_f1_69-scaled.jpeg"),
            creationDate: "2025-06-04T15:56:59+0000",
            isUrgent: true,
            siret: "431 342 910"
        )
    }
    
    static func getFakeItemWithNilContent() -> Item {
        return Item(
            id: 2,
            categoryID: 2,
            title: "Maillot PSG Collector 2025",
            description: "Maillot collector du PSG avec l'étoile pour la victoire historique du trophée de la Ligue des Champions et le flocage collector Champions of Europe 2025.",
            price: 250,
            imagesURL: ImagesURL(small: "https://www.robot-forum.com/images/avatars/f1/13688-f1f6a41d04cf0524a9c6e2147a829aeb241c05b5.jpg", thumb: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fmrowford.com%2Fproducts%2Fmaillot-psg-victoire-ligue-des-champions-edition-lmitee&psig=AOvVaw1BqXyf1iVlyF08-nmW0X8S&ust=1749129250617000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCLjE6LPs140DFQAAAAAdAAAAABAE"),
            creationDate: "2025-06-04T15:56:59+0000",
            isUrgent: false,
            siret: nil
        )
    }
}
