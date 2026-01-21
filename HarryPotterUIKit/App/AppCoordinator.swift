//
//  AppCoordinator.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 16.01.2026.
//

import Foundation
import UIKit

//MARK: - Coordinator Pattern
final class AppCoordinator {
    
    private let window : UIWindow // uygulamanın ana penceresi
    private let navigationController = UINavigationController() //ekranlar arası geçişi yöneten navigasyon yapısı
    
    //initializer
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let mainTabBarController = MainTabBarController()
        navigationController.setViewControllers([mainTabBarController], animated: false) //navigasyon kontrolcüsünün ilk ekranı
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}
