//
//  StringExtensions.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 02/06/2025.
//

import Foundation

func formatPriceInEuros(with price: Int) -> String {
    let numberFormatter = NumberFormatter()
    
    numberFormatter.numberStyle = .currency
    numberFormatter.usesGroupingSeparator = true
    numberFormatter.currencyCode = "EUR"
    numberFormatter.locale = Locale(identifier: "fr_FR")
    numberFormatter.minimumFractionDigits = 0
    numberFormatter.maximumFractionDigits = 2
    
    return numberFormatter.string(from: NSNumber(value: price)) ?? "Prix inconnu"
}
