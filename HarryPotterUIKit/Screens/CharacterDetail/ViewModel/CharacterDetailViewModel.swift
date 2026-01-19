//
//  CharacterDetailViewModel.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 19.01.2026.
//

import Foundation

//homeviewmodelde api çağrısı olduğu için burda tekrar yapmadım
struct CharacterDetailData {
    let fullName: String
    let nickname: String
    let house: String
    let actor: String
    let birthdate: String
    let childrenText: String
    let imageURL: URL?
}

final class CharacterDetailViewModel {

    func makeDetailData(from character: CharacterModel) -> CharacterDetailData {
        let childrenText: String
        if character.children.isEmpty {
            childrenText = "No children"
        } else {
            childrenText = character.children.joined(separator: ", ")
        }

        return CharacterDetailData(
            fullName: character.fullName,
            nickname: character.nickname,
            house: character.hogwartsHouse.rawValue,
            actor: character.interpretedBy.isEmpty ? "Unknown" : character.interpretedBy,
            birthdate: character.birthdate,
            childrenText: childrenText,
            imageURL: URL(string: character.image)
        )
    }
}
