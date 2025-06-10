//
//  LocalSettings.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 09/06/2025.
//

protocol LocalSettings: Sendable {
    func saveSelectedItemCategory(with itemCategory: ItemCategory) async throws
    func loadSelectedItemCategory() async throws -> ItemCategory
}
