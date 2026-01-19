//
//  APIEndpoint.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 19.01.2026.
//

import Foundation

enum APIEndpoint {
    static let baseURL = "https://potterapi-fedeperin.vercel.app"
    static let language = "en"
    
    case houses
    case characters
    case books
    case spells
    
    var path: String {
        switch self {
        case .houses:
            return "/\(APIEndpoint.language)/houses"
        case .books:
            return "/\(APIEndpoint.language)/books"
        case .characters:
            return "/\(APIEndpoint.language)/characters"
        case .spells:
            return "/\(APIEndpoint.language)/spells"
        }
    }
    
    var url: URL? {
        return URL(string: APIEndpoint.baseURL + path)
    }
}
