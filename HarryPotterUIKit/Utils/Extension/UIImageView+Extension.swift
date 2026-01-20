//
//  UIImageView+Extension.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 19.01.2026.
//

import Foundation
import UIKit

//image işlemleri tek bir yerden yönetiliyor.
extension UIImageView {

    func setImage(from urlString: String) {
        Task {
            guard let url = URL(string: urlString) else {
                self.image = UIImage(systemName: "photo")
                return
            }

            do {
                let image = try await ImageLoader.shared.loadImage(from: url)
                self.image = image
            } catch {
                self.image = UIImage(systemName: "photo")
            }
        }
    }
}
