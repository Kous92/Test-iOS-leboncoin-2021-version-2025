//
//  ViewConstants.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 23/06/2025.
//

import Foundation
import UIKit

/// Détermine si l'interface est sur iPhone ou sur iPad
@MainActor fileprivate func isPhone() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

/// Ces constantes sont adaptées aussi bien pour une interface sur iPhone que sur iPad.
@MainActor struct Constants: Sendable {
    @MainActor struct List {
        static let insets: CGFloat = isPhone() ? 16 : 28
        static let spacing: CGFloat = isPhone() ? 8 : 20
        static let spinnerScale: CGFloat = isPhone() ? 2 : 5
    }
    
    @MainActor struct ItemCell {
        static let title: CGFloat = isPhone() ? 14 : 26
        static let category: CGFloat = isPhone() ? 11 : 20
        static let specialLabel: CGFloat = isPhone() ? 12 : 24
        static let urgentRadius: CGFloat = isPhone() ? 7 : 14
        static let urgentVertical: CGFloat = isPhone() ? 5 : 15
    }
    
    @MainActor struct Filter {
        
    }
    
    @MainActor struct Detail {
        static let itemTitle: CGFloat = isPhone() ? 18 : 30
        static let price: CGFloat = isPhone() ? 16: 24
        static let specialLabel: CGFloat = isPhone() ? 12 : 24
        static let urgentRadius: CGFloat = isPhone() ? 15: 25
        static let proRadius: CGFloat = isPhone() ? 10: 20
        static let horizontalMargin: CGFloat = isPhone() ? 10 : 20
        static let titleLabel: CGFloat = isPhone() ? 17 : 30
        static let contentLabel: CGFloat = isPhone() ? 13 : 22
        static let contentViewTopMargin: CGFloat = isPhone() ? -60: -100
        static let contentViewVerticalMargin: CGFloat = isPhone() ? 15: 30
    }
}
