//
//  FavoritesManager.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 20.01.2026.
//

import Foundation

final class FavoritesManager {
    
    static let shared = FavoritesManager()
    private let key = "favorite_characters"
    
    private init() {}
    
    //Hafızadaki favori listesini getirir.
    func getFavorites() -> [Int] {
        UserDefaults.standard.array(forKey: key) as? [Int] ?? []
    }
    
   //Bir karakterin favori olup olmadığını kontrol eder.(favori listesi üzerinden)
    func isFavorite(id: Int) -> Bool {
        getFavorites().contains(id)
    }
    
    //Kullanıcı kalp butonuna bastığında bu fonksiyon çalışır. Karakter zaten favoriyse siler, değilse ekler.
    func toggleFavorite(id: Int) {
        var favorites = getFavorites()
        
        if favorites.contains(id) {//favoriyse sil
            favorites.removeAll { $0 == id }
        } else {//Değilse, favorilere ekle
            favorites.append(id)
        }
        
        UserDefaults.standard.set(favorites, forKey: key)
    }
}

