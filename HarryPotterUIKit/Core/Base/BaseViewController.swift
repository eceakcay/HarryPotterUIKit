//
//  BaseViewController.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 16.01.2026.
//

import UIKit

class BaseViewController: UIViewController {
    
    //Yükleme göstergesi
    private var loadingIndicator : UIActivityIndicatorView?
    
    func showLoading() {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        loadingIndicator = indicator
    }
    
    func hideLoading() {
        loadingIndicator?.removeFromSuperview()
        loadingIndicator = nil
    }
    
    func showError(title: String = "Hata", message: String = "Bir şeyler yanlış gitti") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        
        present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
