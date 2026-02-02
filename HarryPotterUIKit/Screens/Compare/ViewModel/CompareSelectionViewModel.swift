//
//  CompareSelectionViewModel.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 2.02.2026.
//

import Foundation

final class CompareSelectionViewModel {
    
    // API'den karakterleri çeker
    func fetchCharacters() async throws -> [CharacterModel] {
        return try await NetworkService.shared.fetch(endpoint: .characters)
    }
}
