//
//  HomeCell.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 16.01.2026.
//

import UIKit
import SnapKit

final class HomeCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HomeCell"
    
    // MARK: - Theme Colors
    private let creamText = UIColor(red: 0.96, green: 0.93, blue: 0.86, alpha: 1.0)
    private let cardBackground = UIColor(red: 0.20, green: 0.08, blue: 0.08, alpha: 1.0)
    private let goldColor = UIColor(red: 0.85, green: 0.75, blue: 0.45, alpha: 1.0)
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.20, green: 0.08, blue: 0.08, alpha: 1.0)
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let characterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.layer.borderWidth = 1.5
        iv.backgroundColor = UIColor(white: 1, alpha: 0.1)
        iv.tintColor = UIColor(red: 0.85, green: 0.75, blue: 0.45, alpha: 0.6)
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold).withDesign(.serif)
        label.textColor = UIColor(red: 0.96, green: 0.93, blue: 0.86, alpha: 1.0)
        return label
    }()
    
    private let houseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium).withDesign(.serif)
        label.textColor = UIColor(red: 0.96, green: 0.93, blue: 0.86, alpha: 0.7)
        return label
    }()
    
    private let arrowIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(characterImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(houseLabel)
        containerView.addSubview(arrowIcon)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        characterImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        arrowIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(16)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(characterImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(arrowIcon.snp.leading).offset(-8)
            $0.top.equalTo(characterImageView.snp.top).offset(2)
        }
        
        houseLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
    }
    
    // MARK: - Configure
    
    func configure(with character: CharacterModel) {
        nameLabel.text = character.fullName
        houseLabel.text = "🏰 \(character.hogwartsHouse.rawValue)"
        
        let accentColor = houseColor(character.hogwartsHouse)
        
        containerView.layer.borderColor = accentColor.withAlphaComponent(0.6).cgColor
        characterImageView.layer.borderColor = accentColor.cgColor
        arrowIcon.tintColor = accentColor
        
        // Placeholder
        characterImageView.image = UIImage(systemName: "person.crop.circle")
        
        if let url = URL(string: character.image) {
            characterImageView.setImage(from: url.absoluteString)
        }
    }
    
    // MARK: - House Accent Colors
    
    private func houseColor(_ house: HogwartsHouse) -> UIColor {
        switch house {
        case .gryffindor:
            return UIColor(red: 0.55, green: 0.12, blue: 0.15, alpha: 1)
        case .slytherin:
            return UIColor(red: 0.10, green: 0.35, blue: 0.25, alpha: 1)
        case .ravenclaw:
            return UIColor(red: 0.10, green: 0.20, blue: 0.45, alpha: 1)
        case .hufflepuff:
            return UIColor(red: 0.85, green: 0.70, blue: 0.25, alpha: 1)
        }
    }
}
