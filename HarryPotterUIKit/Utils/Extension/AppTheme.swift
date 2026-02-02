//
//  AppTheme.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 21.01.2026.
//

import UIKit

// MARK: - Genel Uygulama Renkleri
extension UIColor {
    
    // Bunları 'static' yaparak her yerden ulaşılabilir kılıyoruz
    static let hpBackground = UIColor(red: 0.05, green: 0.07, blue: 0.12, alpha: 1.0) // Ana Arka Plan
    static let hpCardBackground = UIColor(red: 0.20, green: 0.08, blue: 0.08, alpha: 1.0) // Kart Rengi
    static let hpGold = UIColor(red: 0.85, green: 0.75, blue: 0.45, alpha: 1.0)      // Altın Sarısı
    static let hpCreamText = UIColor(red: 0.96, green: 0.93, blue: 0.86, alpha: 1.0) // Krem Yazı
    static let hpCreamTextSecondary = UIColor(red: 0.96, green: 0.93, blue: 0.86, alpha: 0.7) // Soluk Krem
}

// MARK: - Hogwarts Binalarına Özel Renkler
extension HogwartsHouse {
    
    var color: UIColor {
        switch self {
        case .gryffindor:
            return UIColor(red: 0.55, green: 0.12, blue: 0.15, alpha: 1) // Koyu Kırmızı
        case .slytherin:
            return UIColor(red: 0.10, green: 0.35, blue: 0.25, alpha: 1) // Zümrüt Yeşili
        case .ravenclaw:
            return UIColor(red: 0.10, green: 0.20, blue: 0.45, alpha: 1) // Safir Mavisi
        case .hufflepuff:
            return UIColor(red: 0.85, green: 0.70, blue: 0.25, alpha: 1) // Kanarya Sarısı
        case .unknown:
            return UIColor.systemGray // Bilinmeyen bina için Nötr Gri
        }
    }
}
