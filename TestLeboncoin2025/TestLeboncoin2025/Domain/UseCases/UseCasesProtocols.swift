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
