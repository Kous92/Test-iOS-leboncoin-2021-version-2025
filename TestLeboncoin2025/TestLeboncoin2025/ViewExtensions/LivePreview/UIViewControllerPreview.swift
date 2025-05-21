//
//  UIViewControllerPreview.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 14/05/2025.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI

/// 4 useful formats to see how it renders on different iOS/iPadOS devices. Make sure your Xcode version have the devices with the corresponding name in your simulators list
let deviceNames: [String] = [
    "iPhone 16 Pro",
    "iPhone SE (3rd generation)",
    "iPhone 16e",
    "iPad Pro 11-inch (M4)"
]

/// It allows to live preview a UIViewController made with UIKit with same SwiftUI preview method. Very helpful to save time when making the view (programmatically), to avoir also building every time to check how it looks.
@available(iOS 13, *)
struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> ViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {
        return
    }
}
#endif
