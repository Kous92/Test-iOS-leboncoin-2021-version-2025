//
//  APIError.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 04/06/2025.
//

enum APIError: Error, Sendable {
    case errorMessage(String)
        
    var errorMessageString: String {
        switch self {
        case .errorMessage(let message):
            return message
        }
    }
}
