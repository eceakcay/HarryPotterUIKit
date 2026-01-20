//
//  CompareViewModel.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 19.01.2026.
//

import Foundation

final class CompareViewModel {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared){
        self.networkService = networkService
    }
    
    func compareCharacters(first: CharacterModel, second: CharacterModel) async throws -> (CharacterModel, CharacterModel) {
        async let firstCharacter = fetchCharacters(by: first.fullName)
        async let secondCharacter = fetchCharacters(by: second.fullName)
        
        return try await (firstCharacter, secondCharacter)
    }
    
    private func fetchCharacters(by name: String) async throws -> CharacterModel {
        let characters: [CharacterModel] = try await networkService.fetch(endpoint: .characters)
        guard let character = characters.first(where: { $0.fullName == name }) else {
            throw NSError()
        }
        return character
    }
}
