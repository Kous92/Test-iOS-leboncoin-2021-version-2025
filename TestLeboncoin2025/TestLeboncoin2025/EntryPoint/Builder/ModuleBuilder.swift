//
//  ModuleBuilder.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 14/05/2025.
//


import Foundation
import UIKit

@MainActor protocol ModuleBuilder {
    func buildModule(testMode: Bool, coordinator: ParentCoordinator?) -> UIViewController
}
