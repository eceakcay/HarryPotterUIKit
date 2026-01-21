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
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .hpCardBackground // ⬅️ YENİ KULLANIM
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        // Başlangıç rengi olarak altını veriyoruz, configure'da değişecek
        view.layer.borderColor = UIColor.hpGold.withAlphaComponent(0.3).cgColor
        
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
        iv.tintColor = .hpGold.withAlphaComponent(0.6) // ⬅️ YENİ KULLANIM
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        // Extension eklediysen .withDesign(.serif) kullan, yoksa silip sadece .bold yap
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold).withDesign(.serif)
        label.textColor = .hpCreamText // ⬅️ YENİ KULLANIM
        return label
    }()
    
    private let houseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium).withDesign(.serif)
        label.textColor = .hpCreamTextSecondary // ⬅️ YENİ KULLANIM
        return label
    }()
    
    private let arrowIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .hpGold // Varsayılan renk
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
        
        // ARTIK houseColor fonksiyonuna gerek yok!
        // Enum'ın kendisi rengini biliyor:
        let accentColor = character.hogwartsHouse.color // ⬅️ EN GÜZEL KISIM BURASI
        
        // Hücreyi o binanın rengine göre boyuyoruz
        containerView.layer.borderColor = accentColor.withAlphaComponent(0.6).cgColor
        characterImageView.layer.borderColor = accentColor.cgColor
        arrowIcon.tintColor = accentColor
        
        // Placeholder
        characterImageView.image = UIImage(systemName: "person.crop.circle")
        
        if let url = URL(string: character.image) {
            characterImageView.setImage(from: url.absoluteString)
        }
    }
}
