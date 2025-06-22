//
//  DetailViewModel.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 15/05/2025.
//

import Foundation

final class DetailViewModel {
    weak var coordinator: DetailViewControllerDelegate?
    
    private let itemViewModel: ItemViewModel
    
    // Data binding: liaison entre la vue et la vue modèle: avec Swift 6 et dans un contexte non isolé (nonisolated), la fonction doit être Sendable et dans le MainActor
    var onDataUpdated: (@Sendable @MainActor () -> Void)?
    
    init(with itemViewModel: ItemViewModel) {
        self.itemViewModel = itemViewModel
    }
    
    func getItemViewModel() -> ItemViewModel {
        return itemViewModel
    }
    
    func isUrgentItem() -> Bool {
        return itemViewModel.isUrgent
    }
    
    func isProfessionalSeller() -> Bool {
        return itemViewModel.siret != nil
    }
}

extension DetailViewModel {
    // Navigation
    @MainActor func backToPreviousScreen() {
        coordinator?.backToHomeView()
    }
}
