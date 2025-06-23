//
//  FilterViewModel.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 15/05/2025.
//

import Foundation

@MainActor final class FilterViewModel {
    // Delegate
    weak var coordinator: FilterViewControllerDelegate?
    
    // Use case
    private let loadSavedSelectedCategoryUseCase: LoadSavedSelectedCategoryUseCaseProtocol
    private let saveSelectedCategoriesUseCase: SaveSelectedCategoryUseCaseProtocol
    
    // Liste des catégories
    nonisolated private let itemCategoriesViewModels: [ItemCategoryViewModel]
    private var currentSelectedIndex = 0
    
    // Data binding: liaison entre la vue et la vue modèle: avec Swift 6 et dans un contexte non isolé (nonisolated), la fonction doit être Sendable et dans le MainActor
    var onDataUpdated: (@Sendable @MainActor () -> Void)?
    
    init(with itemCategoriesViewModels: [ItemCategoryViewModel], loadSavedSelectedCategoryUseCase: LoadSavedSelectedCategoryUseCaseProtocol, saveSelectedCategoriesUseCase: SaveSelectedCategoryUseCaseProtocol) {
        self.itemCategoriesViewModels = itemCategoriesViewModels
        self.loadSavedSelectedCategoryUseCase = loadSavedSelectedCategoryUseCase
        self.saveSelectedCategoriesUseCase = saveSelectedCategoriesUseCase
    }
    
    nonisolated func loadSetting() {
        Task.detached { [weak self] in
            do {
                guard let result = try await self?.loadSavedSelectedCategoryUseCase.execute() else {
                    await self?.sendErrorMessage(with: "Une erreur est survenue lors du chargement de la catégorie.")
                    return
                }
                
                print(result)
                await self?.setSelectedCategory(with: result.id)
            } catch APIError.errorMessage(let message) {
                guard message != "nothingSaved" else {
                    return
                }
                
                await self?.sendErrorMessage(with: message)
            }
        }
    }
    
    nonisolated func saveSelectedCategory(at indexPath: IndexPath) {
        Task.detached { [weak self] in
            guard let itemCategoryViewModel = await self?.getItemCategoryViewModel(at: indexPath) else {
                print("[FilterViewModel] Erreur lors de la sélection de la cellule")
                return
            }
            
            print("[FilterViewModel] Catégorie sélectionnée: \(itemCategoryViewModel.name): \(itemCategoryViewModel.id)")
            
            do {
                try await self?.saveSelectedCategoriesUseCase.execute(with: itemCategoryViewModel.getDTO())
                await self?.setSelectedCategory(with: itemCategoryViewModel.id)
                
                await MainActor.run { [weak self] in
                    self?.coordinator?.notifyCategoryUpdate()
                }
            } catch APIError.errorMessage(let message) {
                print(message)
            }
        }
    }
    
    private func setSelectedCategory(with itemCategoryId: Int) async {
        currentSelectedIndex = itemCategoryId
        
        await MainActor.run { [weak self] in
            self?.onDataUpdated?()
        }
    }
}

extension FilterViewModel {
    // MARK: - Logique TableView
    func numberOfItems() -> Int {
        return itemCategoriesViewModels.count
    }
    
    func getCurrentSelectedIndex() -> Int {
        return currentSelectedIndex
    }
    
    func getItemCategoryViewModel(at indexPath: IndexPath) -> ItemCategoryViewModel? {
        // On vérifie bien qu'il y a au moins une cellule dans la liste après filtrage, sinon ça il y aura un crash
        let cellCount = itemCategoriesViewModels.count
        
        guard cellCount > 0, indexPath.row <= cellCount else {
            return nil
        }
        
        return itemCategoriesViewModels[indexPath.item]
    }
    
    // Navigation
    @MainActor func backToPreviousScreen() {
        coordinator?.backToHomeView()
    }
    
    @MainActor private func sendErrorMessage(with errorMessage: String) {
        coordinator?.displayErrorAlert(with: errorMessage)
    }
}
