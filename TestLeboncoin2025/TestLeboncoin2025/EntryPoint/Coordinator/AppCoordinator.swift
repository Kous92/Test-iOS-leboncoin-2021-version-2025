//
//  AppCoordinator.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 14/05/2025.
//

import Foundation
import UIKit
import OSLog

/// The main app Coordinator, the root of navigation flow
@MainActor final class AppCoordinator: Coordinator {
    private let logger = Logger(subsystem: "AppCoordinator", category: "Coordinator")
    
    var childCoordinators = [Coordinator]()
    private let listCoordinator = ListCoordinator(navigationController: UINavigationController(), builder: ListModuleBuilder())
    private let rootViewController: UIViewController
    
    init(with rootViewController: UIViewController = UINavigationController()) {
        // print("[AppCoordinator] Initializing main coordinator")
        logger.info("Initializing main coordinator")
        self.rootViewController = rootViewController
    }
    
    func start() -> UIViewController {
        // print("[AppCoordinator] Setting root view with TabBarController")
        logger.info("Setting root view")
        let listViewController = listCoordinator.start()
        listCoordinator.parentCoordinator = self
                
        return listViewController
    }
}
