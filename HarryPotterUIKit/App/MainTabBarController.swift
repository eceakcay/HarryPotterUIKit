//
//  MainTabBarController.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 21.01.2026.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
        setupViewControllers()
    }
    
    private func setupTabbar() {
        tabBar.barTintColor = .hpBackground
        tabBar.backgroundColor = .hpBackground
        tabBar.tintColor = .hpGold
        tabBar.unselectedItemTintColor = .hpCreamTextSecondary
        
    }
    
    private func setupViewControllers() {
        
        // 1️⃣ HOME
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        // 2️⃣ CHARACTERS
        let characterVC = CharactersViewController()
        let characterNav = UINavigationController(rootViewController: characterVC)
        characterNav.tabBarItem = UITabBarItem(
            title: "Characters",
            image: UIImage(systemName: "person.3"),
            selectedImage: UIImage(systemName: "person.3.fill")
        )
        
        // 3️⃣ FAVORITES
        let favoritesVC = FavoritesViewController()
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        // 4️⃣ COMPARE
        let compareVC = CompareViewController()
        let compareNav = UINavigationController(rootViewController: compareVC)
        compareNav.tabBarItem = UITabBarItem(
            title: "Compare",
            image: UIImage(systemName: "rectangle.split.2x1"),
            selectedImage: UIImage(systemName: "rectangle.split.2x1.fill")
        )
        
        viewControllers = [homeNav, characterNav, favoritesNav, compareNav]
    }
}
