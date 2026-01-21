//
//  HomeHeaderCell.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 21.01.2026.
//

import UIKit
import SnapKit

final class HomeHeaderCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HomeHeaderCell"
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Wizarding World"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold).withDesign(.serif) 
        label.textColor = .hpCreamText
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore houses, books and characters"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light).withDesign(.serif)
        label.textColor = .hpCreamTextSecondary
        label.textAlignment = .center
        return label
    }()
    
    private let bannerImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "hogwarts")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.hpGold.withAlphaComponent(0.3).cgColor
        
        return iv
    }()
    
    private let imageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 10
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        contentView.addSubview(imageContainer)
        imageContainer.addSubview(bannerImageView)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        imageContainer.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        bannerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
