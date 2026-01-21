//
//  BookCell.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 21.01.2026.
//

import UIKit
import SnapKit

final class BookCell: UICollectionViewCell {
    
    static let reuseIdentifier = "BookCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .hpCardBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.hpGold.withAlphaComponent(0.4).cgColor
        return view
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold).withDesign(.serif)
        label.textColor = .hpCreamText
        label.numberOfLines = 2
        return label
    }()
    
    private let infoLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = .hpCreamTextSecondary
        return l
    }()
    
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
    }
    
}
