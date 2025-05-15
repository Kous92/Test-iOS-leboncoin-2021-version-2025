//
//  FilterCoordinator.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 15/05/2025.
//

import Foundation
import UIKit

// Ensure that the 4th and 5th SOLID principles are respected: Interface Segregation and Dependency Inversion
@MainActor protocol FilterViewControllerDelegate: AnyObject {
    func displayErrorAlert(with errorMessage: String)
    func backToHomeView()
}

@MainActor final class FilterCoordinator: ParentCoordinator {
    // Be careful to retain cycle, the sub flow must not hold the reference with the parent.
    weak var parentCoordinator: Coordinator?
    
    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool
    
    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[FilterCoordinator] Initializing.")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }
    
    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[FilterCoordinator] Coordinator destroyed.")
    }
    
    @discardableResult func start() -> UIViewController {
        print("[FilterCoordinator] Instantiating FilterViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let filterViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[FilterCoordinator] Source selection view ready.")
        navigationController.pushViewController(filterViewController, animated: true)
        
        return navigationController
    }
}

extension FilterCoordinator: FilterViewControllerDelegate {
    func backToHomeView() {
        // Removing child coordinator reference
        parentCoordinator?.removeChildCoordinator(childCoordinator: self)
        navigationController.popViewController(animated: true)
        print(navigationController.viewControllers)

    }
    
    func displayErrorAlert(with errorMessage: String) {
        print("[FilterCoordinator] Displaying error alert.")
        
        let alert = UIAlertController(title: String(localized: "error"), message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("OK")
        }))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
}
