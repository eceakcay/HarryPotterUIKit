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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
