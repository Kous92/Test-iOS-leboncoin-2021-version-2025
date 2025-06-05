//
//  APIEndpoint.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 05/06/2025.
//

import Foundation

enum APIEndpoint {
    case fetchItems
    case fetchItemCategories
    
    var baseURL: String {
        return "https://raw.githubusercontent.com/leboncoin/paperclip/master/"
    }
    
    var path: String {
        switch self {
        case .fetchItems:
            return "listing.json"
        case .fetchItemCategories:
            return "categories.json"
        }
    }
}
