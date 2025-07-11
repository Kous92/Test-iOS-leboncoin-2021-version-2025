//
//  UseCasesProtocols.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 04/06/2025.
//

import Foundation

protocol ItemListFetchUseCaseProtocol: Sendable {
    func execute() async throws -> [ItemViewModel]
}

protocol ItemCategoryFetchUseCaseProtocol: Sendable {
    func execute() async throws -> [ItemCategoryViewModel]
}

protocol LoadSavedSelectedCategoryUseCaseProtocol: Sendable {
    func execute() async throws -> ItemCategoryDTO
}

protocol SaveSelectedCategoryUseCaseProtocol: Sendable {
    func execute(with savedCategory: ItemCategoryDTO) async throws
}
