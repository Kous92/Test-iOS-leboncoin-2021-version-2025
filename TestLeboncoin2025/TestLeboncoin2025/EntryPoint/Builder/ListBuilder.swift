//
//  ListBuilder.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 14/05/2025.
//

import UIKit

final class ListModuleBuilder: ModuleBuilder {
    private var testMode = false
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        // Get ViewController instance: view layer
        let listViewController = ListViewController()
        
        // Dependency injections for ViewModel, building the presentation, domain and data layers
        // 1) Get repository instances: data layer
        let dataRepository = getRepository(testMode: testMode)
        let loadRepository = getLoadRepository(testMode: testMode)
        
        // 2) Get use case instances: domain layer
        let itemCategoryFetchUseCase = ItemCategoryFetchUseCase(dataRepository: dataRepository)
        let itemListFetchUseCase = ItemListFetchUseCase(dataRepository: dataRepository)
        let loadSavedSelectedSourceUseCase = LoadSavedSelectedSourceUseCase(itemCategorySettingsRepository: loadRepository)
        
        // 3) Get view model instance: presentation layer. Injecting all needed use cases.
        let listViewModel = ListViewModel(itemCategoryFetchUseCase: itemCategoryFetchUseCase, itemListFetchUseCase: itemListFetchUseCase, loadSavedSelectedSourceUseCase: loadSavedSelectedSourceUseCase)
        
        // 4) Injecting coordinator for presentation layer
        listViewModel.coordinator = coordinator as? ListViewControllerDelegate
        
        // 5) Injecting view model to the view
        listViewController.viewModel = listViewModel
        
        return listViewController
    }
    
    private func getRepository(testMode: Bool) -> Repository {
        return DataRepository(apiService: getDataService(testMode: testMode))
    }
    
    private func getLoadRepository(testMode: Bool) -> ItemCategorySettingsRepository {
        return ItemCategoryUserDefaultsRepository(localSettings: getLocalSettings(testMode: testMode))
    }
    
    private func getDataService(testMode: Bool) -> APIService {
        // return testMode ? NetworkMockAPIService()(forceFetchFailure: false) : NetworkAPIService()
        return NetworkAPIService()
    }
    
    private func getLocalSettings(testMode: Bool) -> LocalSettings {
        return UserDefaultsLocalSettings()
    }
}
