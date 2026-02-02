//
//  FavoritesManager.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 20.01.2026.
//

import Foundation

final class FavoritesManager {
    static let shared = FavoritesManager()
    private let key = "FavoriteCharacterIDs" // Hafıza anahtarı
    
    private init() {}
    
    // Favori mi diye kontrol et
    func isFavorite(id: Int) -> Bool {
        let savedIds = getFavorites()
        return savedIds.contains(id)
    }
    
    // Ekle / Çıkar
    func toggleFavorite(id: Int) {
        var savedIds = getFavorites()
        
        if savedIds.contains(id) {
            savedIds.removeAll { $0 == id } // Varsa sil
        } else {
            savedIds.append(id) // Yoksa ekle
        }
        
        UserDefaults.standard.set(savedIds, forKey: key)
    }
    
    // Kayıtlı listeyi getir
    func getFavorites() -> [Int] {
        return UserDefaults.standard.array(forKey: key) as? [Int] ?? []
    }
}
