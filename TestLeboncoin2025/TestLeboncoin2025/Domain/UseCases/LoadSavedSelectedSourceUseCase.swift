//
//  LoadSavedSelectedSourceUseCase.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 09/06/2025.
//

final class LoadSavedSelectedSourceUseCase: LoadSavedSelectedCategoryUseCaseProtocol {
    private let itemCategorySettingsRepository: ItemCategorySettingsRepository
    
    nonisolated init(itemCategorySettingsRepository: ItemCategorySettingsRepository) {
        self.itemCategorySettingsRepository = itemCategorySettingsRepository
    }
    
    func execute() async throws -> ItemCategoryDTO {
        return try await itemCategorySettingsRepository.loadSelectedItemCategory()
    }
}
