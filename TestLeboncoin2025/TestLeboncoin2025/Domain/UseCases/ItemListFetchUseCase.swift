//
//  ItemListFetchUseCase.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 05/06/2025.
//

final class ItemListFetchUseCase: ItemListFetchUseCaseProtocol {
    private let dataRepository: Repository
    
    nonisolated init(dataRepository: Repository) {
        self.dataRepository = dataRepository
    }
    
    func execute() async throws -> [ItemViewModel] {
        print("Récupération des items")
        return handleResult(with: try await dataRepository.fetchItems())
    }
    
    private func handleResult(with result: [ItemDTO]) -> [ItemViewModel] {
        parseViewModels(with: result)
    }
    
    private func parseViewModels(with items: [ItemDTO]) -> [ItemViewModel] {
        var viewModels = [ItemViewModel]()
        items.forEach { viewModels.append(ItemViewModel(with: $0)) }
        
        return viewModels
    }
}
