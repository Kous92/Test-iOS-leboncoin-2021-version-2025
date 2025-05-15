//
//  FilterBuilder.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 15/05/2025.
//

import UIKit

final class FilterModuleBuilder: ModuleBuilder {
    private var testMode = false
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        // Get ViewController instance: view layer
        let filterViewController = FilterViewController()
        
        /*
        // Dependency injections for ViewModel, building the presentation, domain and data layers
        // 1) Get repository instances: data layer
        let dataRepository = getRepository(testMode: testMode)
        let sourceSettingsRepository = getSettingsRepository(testMode: testMode)
        let userSettingsRepository = getUserSettingsRepository(testMode: testMode)
        
        // 2) Get use case instances: domain layer
        let ListUseCase = ListUseCase(dataRepository: dataRepository)
        let loadSavedSelectedSourceUseCase = LoadSavedSelectedSourceUseCase(sourceSettingsRepository: sourceSettingsRepository)
        let loadUserSettingsUseCase = LoadUserSettingsUseCase(userSettingsRepository: userSettingsRepository)
        
        // 3) Get view model instance: presentation layer. Injecting all needed use cases.
        let ListViewModel = ListViewModel(ListUseCase: ListUseCase, loadSavedSelectedSourceUseCase: loadSavedSelectedSourceUseCase, loadUserSettingsUseCase: loadUserSettingsUseCase)
         */
        let filterViewModel = FilterViewModel()
        
        // 4) Injecting coordinator for presentation layer
        filterViewModel.coordinator = coordinator as? FilterViewControllerDelegate
        
        // 5) Injecting view model to the view
        filterViewController.viewModel = filterViewModel
        
        return filterViewController
    }
}
