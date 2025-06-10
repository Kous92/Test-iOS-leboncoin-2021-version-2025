//
//  UserDefaultsLocalSettings.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 09/06/2025.
//

import Foundation

final class UserDefaultsLocalSettings: LocalSettings {
    func saveSelectedItemCategory(with itemCategory: ItemCategory) async throws {
        print("[UserDefaultsLocalSettings] Sauvegarde de la catégorie: \(itemCategory.name), id: \(itemCategory.id)")
        
        do {
            // L'encodage est nécessaire avant sauvegarde d'un objet
            let encoder = JSONEncoder()
            let data = try encoder.encode(itemCategory)

            // Sauvegarde
            UserDefaults.standard.set(data, forKey: "savedSource")
        } catch {
            throw APIError.errorMessage("Une erreur est survenue lors de l'encodage de la catégorie à sauvegarder. \(error)")
        }
    }
    
    func loadSelectedItemCategory() async throws -> ItemCategory {
        print("[UserDefaultsLocalSettings] Chargement de la catégorie sauvegardée.")
        
        if let data = UserDefaults.standard.data(forKey: "savedSource") {
            do {
                // Le chargement d'un objet se fait avec un décodage
                let decoder = JSONDecoder()
                let itemCategory = try decoder.decode(ItemCategory.self, from: data)
                
                // Done, notify that loading has succeeded
                return itemCategory
            } catch {
                print("[SuperNewsUserDefaultsLocalSettings] ERROR: Unable to decode the loaded source (\(error))")
                throw APIError.errorMessage("")
            }
        }
        
        throw APIError.errorMessage("Aucune catégorie n'a été sauvegardée.")
    }
}
