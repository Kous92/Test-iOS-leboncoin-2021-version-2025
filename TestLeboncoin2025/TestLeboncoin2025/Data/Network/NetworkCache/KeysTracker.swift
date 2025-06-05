//
//  KeysTracker.swift
//  TestLeboncoin2025
//
//  Created by Koussaïla Ben Mamar on 05/06/2025.
//
import Foundation

/// Tracks all of the keys used with NSCache to load and save data.
final class KeysTracker<T>: NSObject, NSCacheDelegate {
    var keys = Set<String>()
    
    // From NSCacheDelegate, called when an object will be removed from cache.
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        guard let entry = obj as? CacheEntry<T> else {
            return
        }
        
        keys.remove(entry.key)
    }
}
