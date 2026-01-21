//
//  HomeViewModel.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 16.01.2026.
//

import Foundation

final class CharactersViewModel {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    //burada apiden karakterleri çekiyoruz
    func fetchCharacters() async throws -> [CharacterModel] {
        return try await networkService.fetch(endpoint: .characters)
    }
}
