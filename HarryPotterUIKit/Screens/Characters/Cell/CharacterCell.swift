//
//  CharacterCell.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 16.01.2026.
//

import UIKit
import SnapKit

final class CharacterCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HomeCell"
    
    // Callback: Butona basıldığında dışarıya (ViewController'a) haber vermek için
    var onFavoriteTapped: (() -> Void)?
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .hpCardBackground
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
        iv.tintColor = .hpGold.withAlphaComponent(0.6)
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        // Extension eklediysen .withDesign(.serif) kullan, yoksa silip sadece .bold yap
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold).withDesign(.serif)
        label.textColor = .hpCreamText
        return label
    }()
    
    private let houseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium).withDesign(.serif)
        label.textColor = .hpCreamTextSecondary
        return label
    }()
    
    // private let arrowIcon... (Yorum satırı olarak kalsın)
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        return button
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
        // containerView.addSubview(arrowIcon)
        containerView.addSubview(favoriteButton)
        
        // Buton aksiyonunu burada sadece BİR kere ekliyoruz
        favoriteButton.addTarget(self, action: #selector(handleFavoriteButtonTap), for: .touchUpInside)
        
        // Constraints
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        characterImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(characterImageView.snp.trailing).offset(12)
            $0.top.equalTo(characterImageView.snp.top).offset(2)
        }
        
        houseLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleFavoriteButtonTap() {
        // Butona basılınca closure'ı tetikle
        onFavoriteTapped?()
    }
    
    // MARK: - Configure
    
    func configure(with character: CharacterModel) {
        nameLabel.text = character.fullName
        houseLabel.text = "🏰 \(character.hogwartsHouse.rawValue)"
        
        let accentColor = character.hogwartsHouse.color
        
        // Hücreyi o binanın rengine göre boyuyoruz
        containerView.layer.borderColor = accentColor.withAlphaComponent(0.6).cgColor
        characterImageView.layer.borderColor = accentColor.cgColor
        
        // Placeholder
        characterImageView.image = UIImage(systemName: "person.crop.circle")
        
        if let url = URL(string: character.image) {
            characterImageView.setImage(from: url.absoluteString)
        }
        
        // --- FAVORİ LOGIC ---
        
        // 1. Mevcut durumu kontrol et ve ikonu ayarla
        let isFav = FavoritesManager.shared.isFavorite(id: character.index)
        let iconName = isFav ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: iconName), for: .normal)
        
        // 2. Closure tanımla: Butona basıldığında ne yapılacak?
        self.onFavoriteTapped = { [weak self] in
            guard let self = self else { return }
            
            // Manager'da durumu değiştir (Ekle/Çıkar)
            FavoritesManager.shared.toggleFavorite(id: character.index)
            
            // Yeni durumu kontrol et
            let newStatus = FavoritesManager.shared.isFavorite(id: character.index)
            let newIcon = newStatus ? "heart.fill" : "heart"
            
            // İkonu hemen güncelle (Animasyonlu)
            UIView.animate(withDuration: 0.1) {
                self.favoriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            } completion: { _ in
                self.favoriteButton.setImage(UIImage(systemName: newIcon), for: .normal)
                UIView.animate(withDuration: 0.1) {
                    self.favoriteButton.transform = .identity
                }
            }
        }
    }
}
