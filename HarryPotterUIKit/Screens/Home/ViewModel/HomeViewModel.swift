//
//  HomeViewModel.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 21.01.2026.
//

import Foundation

final class HomeViewModel {
    
    // Ekranda gösterilecek kartların listesi
    private let menuItems: [HomeCardView.CardType] = [
        .characters,
        .books,
        .houses
    ]
    
    // CollectionView'a kaç tane hücre çizeceğini söyler
    var numberOfItems: Int {
        return menuItems.count
    }
    
    // İlgili sıradaki (index) kartın tipini döner
    func getItem(at index: Int) -> HomeCardView.CardType {
        return menuItems[index]
    }
}
