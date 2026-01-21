//
//  Book.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 19.01.2026.
//

import Foundation

struct Book : Codable {
    let number: Int
    let title: String
    let originalTitle: String
    let releaseDate: String
    let description: String
    let pages: Int
    let cover: String
    let index: Int
  
    var releaseDateFormatted: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.date(from: releaseDate)
        
    }
}
