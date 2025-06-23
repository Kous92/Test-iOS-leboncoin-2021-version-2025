//
//  ListCoordinator.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 14/05/2025.
//

import Foundation
import UIKit

// On 4th and 5th SOLID principles of Interface Segregation and Dependency Inversion
@MainActor protocol ListViewControllerDelegate: AnyObject {
    func goToDetailView(with itemViewModel: ItemViewModel)
    func goToFilterView(with itemCategoriesViewModels: [ItemCategoryViewModel])
    func displayErrorAlert(with errorMessage: String)
    func notifyCategoryUpdate()
}

@MainActor final class ListCoordinator: ParentCoordinator {
    // Attention à la rétention de cycle, le sous-flux ne doit pas retenir la référence avec le parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[ListCoordinator] Initializing")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }
    
    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[ListCoordinator] Coordinator destroyed.")
    }
    
    func start() -> UIViewController {
        print("[ListCoordinator] Instantiating ListViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let ListViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[ListCoordinator] List view ready.")
        navigationController.pushViewController(ListViewController, animated: false)
        
        return navigationController
    }
}

extension ListCoordinator: ListViewControllerDelegate {
    func goToDetailView(with itemViewModel: ItemViewModel) {
        // Transition is separated here into a child coordinator.
        print("[ListCoordinator] Setting child coordinator: DetailCoordinator.")
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, builder: DetailModuleBuilder(itemViewModel: itemViewModel))
        
        // Adding link to the parent with self, be careful to retain cycle
        detailCoordinator.parentCoordinator = self
        addChildCoordinator(childCoordinator: detailCoordinator)
        
        // Transition from home screen to source selection screen
        print("[ListCoordinator] Go to DetailViewController.")
        detailCoordinator.start()
    }
    
    func goToFilterView(with itemCategoriesViewModels: [ItemCategoryViewModel]) {
        // Transition is separated here into a child coordinator.
        print("[ListCoordinator] Setting child coordinator: FilterCoordinator.")
        let filterCoordinator = FilterCoordinator(navigationController: navigationController, builder: FilterModuleBuilder(with: itemCategoriesViewModels))
        
        // Adding link to the parent with self, be careful to retain cycle
        filterCoordinator.parentCoordinator = self
        addChildCoordinator(childCoordinator: filterCoordinator)
        
        // Transition from home screen to source selection screen
        print("[ListCoordinator] Go to FilterViewController.")
        filterCoordinator.start()
    }
    
    func displayErrorAlert(with errorMessage: String) {
        print("[ListCoordinator] Displaying error alert.")
        
        let alert = UIAlertController(title: String(localized: "error"), message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func notifyCategoryUpdate() {
        if let listViewController = navigationController.viewControllers.first as? ListViewController {
            listViewController.viewModel?.updateCategoryFilter()
        }
    }
}
