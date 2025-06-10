//
//  SaveSelectedSourceUseCase.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 09/06/2025.
//

final class SaveSelectedSourceUseCase: SaveSelectedCategoryUseCaseProtocol {
    
    private let itemCategorySettingsRepository: ItemCategorySettingsRepository
    
    nonisolated init(itemCategorySettingsRepository: ItemCategorySettingsRepository) {
        self.itemCategorySettingsRepository = itemCategorySettingsRepository
    }
    
    func execute(with savedCategory: ItemCategoryDTO) async throws {
        try await itemCategorySettingsRepository.saveSelectedItemCategory(with: savedCategory)
    }
}
