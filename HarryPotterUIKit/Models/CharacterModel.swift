//
//  CharacterModel.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 19.01.2026.
//

import Foundation

struct CharacterModel: Codable, Hashable {
    let index: Int
    let fullName: String
    let nickname: String
    let hogwartsHouse: HogwartsHouse
    let interpretedBy: String
    let children: [String]
    let image: String
    let birthdate: String
    
    // YENİ EKLENEN ALANLAR (Hata verenler)
    // API'den gelmeme ihtimaline karşı opsiyonel yapıyoruz
    let species: String?
    let ancestry: String?
    let patronus: String?
    // actor yerine interpretedBy kullanmışsın, onu koruduk ama aşağıda kullanacağız.
}

enum HogwartsHouse: String, Codable {
    case gryffindor = "Gryffindor"
    case hufflepuff = "Hufflepuff"
    case ravenclaw = "Ravenclaw"
    case slytherin = "Slytherin"
    
    // Eğer API'den boş gelirse veya eşleşmezse patlamasın diye
    case unknown = "Unknown"
    
    // Decoder hata verirse varsayılan olarak .unknown atar
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try? container.decode(String.self)
        self = HogwartsHouse(rawValue: rawValue ?? "") ?? .unknown
    }
}
