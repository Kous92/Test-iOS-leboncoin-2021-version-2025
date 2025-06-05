//
//  ItemCategoryFetchUseCase.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 05/06/2025.
//

final class ItemCategoryFetchUseCase: ItemCategoryFetchUseCaseProtocol {
    private let dataRepository: Repository
    
    nonisolated init(dataRepository: Repository) {
        self.dataRepository = dataRepository
    }
    
    func execute() async throws -> [ItemCategoryViewModel] {
        print("Récupération des catégories d'items")
        return handleResult(with: try await dataRepository.fetchItemCategories())
    }
    
    private func handleResult(with result: [ItemCategoryDTO]) -> [ItemCategoryViewModel] {
        parseViewModels(with: result)
    }
    
    private func parseViewModels(with itemCategories: [ItemCategoryDTO]) -> [ItemCategoryViewModel] {
        var viewModels = [ItemCategoryViewModel]()
        itemCategories.forEach { viewModels.append(ItemCategoryViewModel(with: $0)) }
        
        return viewModels
    }
}
