//
//  HomeViewModel.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 16.01.2026.
//

import Foundation

final class HomeViewModel {
    
    func fetchCharacters() -> [HomeCharacter] {
        return [
            HomeCharacter(id: UUID(), name: "Harry Potter", house: "Gryffindor"),
            HomeCharacter(id: UUID(), name: "Hermione Granger", house: "Gryffindor"),
            HomeCharacter(id: UUID(), name: "Draco Malfoy", house: "Slytherin")
        ]
    }
}
