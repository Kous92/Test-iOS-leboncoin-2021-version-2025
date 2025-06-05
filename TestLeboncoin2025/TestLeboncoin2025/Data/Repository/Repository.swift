//
//  Repository.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 04/06/2025.
//

protocol Repository: Sendable {
    func fetchItems() async throws -> [ItemDTO]
    func fetchItemCategories() async throws -> [ItemCategoryDTO]
}
