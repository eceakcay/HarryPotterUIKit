//
//  APIEndpoint.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 19.01.2026.
//

import Foundation

enum APIEndpoint {
    static let baseURL = "http://localhost:3000"

    case houses
    case characters
    case books
    case spells

    var path: String {
        switch self {
        case .houses:
            return "/en_houses"
        case .books:
            return "/en_books"
        case .characters:
            return "/en_characters"
        case .spells:
            return "/en_spells"
        }
    }

    var url: URL? {
      return URL(string: APIEndpoint.baseURL + path)
    }
}

