//
//  FilterBuilder.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 15/05/2025.
//

import UIKit

final class FilterModuleBuilder: ModuleBuilder {    
    private var testMode = false
    private let itemCategoriesViewModels: [ItemCategoryViewModel]
    
    init(with itemCategoriesViewModels: [ItemCategoryViewModel]) {
        self.itemCategoriesViewModels = itemCategoriesViewModels
    }
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        // Get ViewController instance: view layer
        let filterViewController = FilterViewController()
        
        // Dependency injections for ViewModel, building the presentation, domain and data layers
        // 1) Get repository instances: data layer
        let saveRepository = getSaveRepository(testMode: testMode)
        let loadRepository = getLoadRepository(testMode: testMode)
        
        // 2) Get use case instances: domain layer
        let loadSavedSelectedSourceUseCase = LoadSavedSelectedSourceUseCase(itemCategorySettingsRepository: loadRepository)
        let saveSelectedSourceUseCase = SaveSelectedSourceUseCase(itemCategorySettingsRepository: saveRepository)
        
        // Dependency injection for ViewModel, building the presentation layer. Data and domain are not needed
        let filterViewModel = FilterViewModel(with: itemCategoriesViewModels, loadSavedSelectedCategoryUseCase: loadSavedSelectedSourceUseCase, saveSelectedCategoriesUseCase: saveSelectedSourceUseCase)
        
        // 4) Injecting coordinator for presentation layer
        filterViewModel.coordinator = coordinator as? FilterViewControllerDelegate
        
        // 5) Injecting view model to the view
        filterViewController.viewModel = filterViewModel
        
        return filterViewController
    }
    
    private func getLoadRepository(testMode: Bool) -> ItemCategorySettingsRepository {
        return ItemCategoryUserDefaultsRepository(localSettings: getLocalSettings(testMode: testMode))
    }
    
    private func getSaveRepository(testMode: Bool) -> ItemCategorySettingsRepository {
        return ItemCategoryUserDefaultsRepository(localSettings: getLocalSettings(testMode: testMode))
    }
    
    private func getLocalSettings(testMode: Bool) -> LocalSettings {
        return UserDefaultsLocalSettings()
    }
}
