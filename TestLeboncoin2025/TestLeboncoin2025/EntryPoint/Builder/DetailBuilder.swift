//
//  DetailBuilder.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 15/05/2025.
//

import UIKit

final class DetailModuleBuilder: ModuleBuilder {
    private var testMode = false
    private let itemViewModel: ItemViewModel
    
    init(itemViewModel: ItemViewModel) {
        self.itemViewModel = itemViewModel
    }
    
    func buildModule(testMode: Bool, coordinator: ParentCoordinator? = nil) -> UIViewController {
        self.testMode = testMode
        let detailViewController = DetailViewController()
        
        // Dependency injection. Don't forget to inject the coordinator delegate reference for navigation actions.
        let detailViewModel = DetailViewModel(with: itemViewModel)
        detailViewModel.coordinator = coordinator as? DetailViewControllerDelegate
        detailViewController.configure(with: detailViewModel)
        
        return detailViewController
    }
}
