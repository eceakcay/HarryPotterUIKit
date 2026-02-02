//
//  BaseViewController.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 16.01.2026.
//

import UIKit

class BaseViewController: UIViewController {
    
    // Yükleme göstergesi
    private var loadingIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ortak arka plan rengini burada set edebilirsin
        view.backgroundColor = .hpBackground
    }
    
    func showLoading() {
        // UI işlemini ana thread'e alıyoruz
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Eğer zaten varsa tekrar ekleme
            if self.loadingIndicator != nil { return }
            
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.center = self.view.center
            indicator.color = .label // Temaya uygun renk (Dark/Light mode)
            indicator.startAnimating()
            self.view.addSubview(indicator)
            self.loadingIndicator = indicator
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator?.removeFromSuperview()
            self?.loadingIndicator = nil
        }
    }
    
    func showError(title: String = "Hata", message: String = "Bir şeyler yanlış gitti") {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
