//
//  FavoritesViewModel.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 21.01.2026.
//

import Foundation

final class FavoritesViewModel {
    
    private var allCharactersCache: [CharacterModel] = []
    
    // Favori karakterleri getirir
    func fetchFavorites() async throws -> [CharacterModel] {
        
        if allCharactersCache.isEmpty {
            let fetchedCharacters: [CharacterModel] = try await NetworkService.shared.fetch(endpoint: .characters)
            self.allCharactersCache = fetchedCharacters
        }
        
        let favoriteIDs = FavoritesManager.shared.getFavorites()
        let favorites = allCharactersCache.filter { favoriteIDs.contains($0.index) }
        
        return favorites
    }
}
