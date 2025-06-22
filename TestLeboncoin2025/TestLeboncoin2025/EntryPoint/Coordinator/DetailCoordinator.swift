//
//  DetailCoordinator.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 15/05/2025.
//

import UIKit
// Ensure that the 4th and 5th SOLID principles are respected: Interface Segregation and Dependency Inversion
@MainActor protocol DetailViewControllerDelegate: AnyObject {
    func backToHomeView()
}

@MainActor final class DetailCoordinator: ParentCoordinator {
    // Be careful to retain cycle, the subflow must not hold the reference with the parent.
    weak var parentCoordinator: Coordinator?

    private(set) var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var builder: ModuleBuilder
    private let testMode: Bool

    init(navigationController: UINavigationController, builder: ModuleBuilder, testMode: Bool = false) {
        print("[DetailCoordinator] Initializing.")
        self.navigationController = navigationController
        self.builder = builder
        self.testMode = testMode
    }

    // Make sure that the coordinator is destroyed correctly, useful for debug purposes
    deinit {
        print("[DetailCoordinator] Coordinator destroyed.")
    }
    
    @discardableResult func start() -> UIViewController {
        print("[DetailCoordinator] Instantiating DetailViewController.")
        // The module is properly set with all necessary dependency injections (ViewModel, UseCase, Repository and Coordinator)
        let DetailViewController = builder.buildModule(testMode: self.testMode, coordinator: self)
        
        print("[DetailCoordinator] Article detail view ready.")
        navigationController.pushViewController(DetailViewController, animated: true)
        
        return navigationController
    }
}

extension DetailCoordinator: DetailViewControllerDelegate {
    func backToHomeView() {
        // Removing child coordinator reference
        parentCoordinator?.removeChildCoordinator(childCoordinator: self)
        print(navigationController.viewControllers)

    }
}
