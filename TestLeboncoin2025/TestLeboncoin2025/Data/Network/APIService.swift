//
//  APIService.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 04/06/2025.
//

protocol APIService: Sendable {
    func fetchItems() async throws -> [Item]
    func fetchItemCategories() async throws -> [ItemCategory]
}
