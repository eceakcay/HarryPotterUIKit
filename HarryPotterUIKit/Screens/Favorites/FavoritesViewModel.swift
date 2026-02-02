//
//  FavoritesViewModel.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 21.01.2026.
//

import Foundation

final class FavoritesViewModel {
    
    // Veriyi her seferinde internetten çekmemek için basit bir önbellek (Cache)
    private var allCharactersCache: [CharacterModel] = []
    
    /// Favori karakterleri getirir
    func fetchFavorites() async throws -> [CharacterModel] {
        
        // 1. Eğer elimizde hiç veri yoksa, önce internetten çekip önbelleğe atalım
        if allCharactersCache.isEmpty {
            let fetchedCharacters: [CharacterModel] = try await NetworkService.shared.fetch(endpoint: .characters)
            self.allCharactersCache = fetchedCharacters
        }
        
        // 2. Hafızadaki favori ID'lerini al
        let favoriteIDs = FavoritesManager.shared.getFavorites()
        
        // 3. Tüm karakterler içinden ID'si favorilerde olanları filtrele
        let favorites = allCharactersCache.filter { favoriteIDs.contains($0.index) }
        
        return favorites
    }
}
