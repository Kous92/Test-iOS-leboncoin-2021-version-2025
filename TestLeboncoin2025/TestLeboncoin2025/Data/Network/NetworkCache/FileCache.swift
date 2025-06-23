//
//  FileCache.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 05/06/2025.
//
import Foundation

/**
 Manages the persistent file cache of any data type to prevent downloading same data more than one time. Also, with an `actor` (reference type), it's used to be safe in concurrent environments, meaning with multiple threads (here from `Task` blocks and `async` functions), to prevent data races (unpredictable behaviors, memory corruption, crashes) thanks to a dedicated synchronized access to its isolated data). The data will be accessed with `await` into `async` functions.
    
 Also, this cache manager has an expiration date to make sure when the time interval is expired, to allow the app downloading new data.
 */
actor FileCache<T: Codable>: NSCacheType {
    // NSCache is used to store data in cache and avoid to download more than one time the same data, also thread safe to avoid data corruption when accessed from multiple threads (tasks).
    let cache: NSCache<NSString, CacheEntry<T>> = .init()
    var keysTracker: KeysTracker<T> = .init()
    let expirationInterval: TimeInterval
    let fileName: String
    
    init(fileName: String, expirationInterval: TimeInterval) {
        self.fileName = fileName
        self.expirationInterval = expirationInterval
    }
    
    private var saveLocationURL: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(fileName).cache")
    }
    
    func saveToDisk() {
        let entries = keysTracker.keys.compactMap(entry)
        print("[FileCache] Sauvegarde en cache de \(entries.count) entrées.")
        
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: saveLocationURL)
        } catch {
            print("[FileCache] Échec de la sauvegarde, une erreur est survenue: \(error.localizedDescription)")
            return
        }
        
        print("[FileCache] Sauvegarde réussie.")
    }
    
    func loadFromDisk() {
        print("[FileCache] Chargement des données du fichier cache \(fileName)...")
        
        do {
            let data = try Data(contentsOf: saveLocationURL)
            let entries = try JSONDecoder().decode([CacheEntry<T>].self, from: data)
            entries.forEach { insert($0) }
            print("[FileCache] Chargement réussi. \(entries.count > 0 ? String(entries.count) : "No") entrée disponible en cache.")
        } catch {
            print("[FileCache] Échec du chargement, une erreur est survenue: \(error.localizedDescription)")
            return
        }
    }
}
