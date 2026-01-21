//
//  CharacterModel.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 19.01.2026.
//

import Foundation

struct CharacterModel: Codable, Hashable {
    let fullName, nickname: String
    let hogwartsHouse: HogwartsHouse
    let interpretedBy: String
    let children: [String]
    let image: String
    let birthdate: String
    let index: Int
}

enum HogwartsHouse: String, Codable {
    case gryffindor = "Gryffindor"
    case hufflepuff = "Hufflepuff"
    case ravenclaw = "Ravenclaw"
    case slytherin = "Slytherin"
}
