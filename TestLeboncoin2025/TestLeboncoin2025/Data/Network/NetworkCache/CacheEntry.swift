//
//  CacheEntry.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 05/06/2025.
//
import Foundation

/// Cet objet permet de contenir n'importe quel type de données pour les sauvegarder/charger depuis le cache avec une temps avant expiration.
final class CacheEntry<T> {

    let key: String
    let value: T
    let expiredTimestamp: Date
    
    init(key: String, value: T, expiredTimestamp: Date) {
        self.key = key
        self.value = value
        self.expiredTimestamp = expiredTimestamp
    }
    
    /// Vérifie si les données en caches sont expirées
    func isCacheExpired(after date: Date) -> Bool {
        date > expiredTimestamp
    }
}

// CacheEntry supporte les objets encodables et décodables
extension CacheEntry: Codable where T: Codable {}
