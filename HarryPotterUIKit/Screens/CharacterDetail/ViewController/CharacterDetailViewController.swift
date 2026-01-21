//
//  CharacterDetailViewController.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 19.01.2026.
//

import UIKit
import SnapKit

final class CharacterDetailViewController: BaseViewController {

    // MARK: - Properties
    private let viewModel = CharacterDetailViewModel()
    private let character: CharacterModel

    // MARK: - UI Components

    private let characterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.backgroundColor = UIColor(white: 1, alpha: 0.1)
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold).withDesign(.serif)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let nicknameLabel = DetailLabel(fontSize: 18, alpha: 0.9)
    private let houseLabel    = DetailLabel(fontSize: 16, alpha: 0.85)
    private let actorLabel    = DetailLabel(fontSize: 16, alpha: 0.85)
    private let birthdateLabel = DetailLabel(fontSize: 16, alpha: 0.85)
    
    private let childrenLabel: UILabel = {
        let label = DetailLabel(fontSize: 16, alpha: 0.85)
        label.numberOfLines = 0
        label.textAlignment = .left // Çocuk isimleri alt alta liste gibi duracağı için sola yaslı
        return label
    }()

    // MARK: - Init
    init(character: CharacterModel) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .hpBackground
        title = character.fullName
        
        setupUI()
        bindData()
        setupFavoriteButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        characterImageView.layer.cornerRadius = characterImageView.frame.height / 2
    }

    // MARK: - Setup UI
    private func setupUI() {
        let container = UIView()
        container.backgroundColor = .hpCardBackground // ⬅️ YENİ
        container.layer.cornerRadius = 24
        container.layer.borderWidth = 1
        
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 4)
        container.layer.shadowOpacity = 0.5
        container.layer.shadowRadius = 8
        
        let infoStack = UIStackView(arrangedSubviews: [
            nameLabel,
            nicknameLabel,
            houseLabel,
            actorLabel,
            birthdateLabel,
            childrenLabel
        ])
        
        infoStack.axis = .vertical
        infoStack.spacing = 14
        infoStack.alignment = .center
        
        view.addSubview(container)
        view.addSubview(characterImageView)
        container.addSubview(infoStack)
        
        let imageSize: CGFloat = 140
        
        characterImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(container.snp.top)
            $0.width.height.equalTo(imageSize)
        }
        
        container.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(imageSize / 2 + 20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview().inset(40)
        }
        
        infoStack.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    // MARK: - Bind Data
    private func bindData() {
        let data = viewModel.makeDetailData(from: character)
        
        let accent = character.hogwartsHouse.color
        
        nameLabel.text = data.fullName.uppercased()
        nameLabel.textColor = accent
        
        nicknameLabel.text = data.nickname.isEmpty ? nil : "\"\(data.nickname)\""
        houseLabel.text = "🏰 \(data.house)"
        actorLabel.text = "Played by: \(data.actor)"
        birthdateLabel.text = "Born: \(data.birthdate)"
        
        childrenLabel.text = data.childrenText.isEmpty
            ? nil
            : "Children:\n• " + data.childrenText.replacingOccurrences(of: ", ", with: "\n• ")
        
        // Konteyner çerçevesini de binanın rengine boyayalım
        if let container = view.subviews.first(where: { $0.backgroundColor == .hpCardBackground }) {
            container.layer.borderColor = accent.withAlphaComponent(0.5).cgColor
        }
        
        characterImageView.layer.borderColor = accent.cgColor
        
        if let url = data.imageURL {
            characterImageView.setImage(from: url.absoluteString)
        }
    }
    
    //MARK: - Favorite Button
    private func setupFavoriteButton() {
        let isFav = FavoritesManager.shared.isFavorite(id: character.index)
        let icon = isFav ? "heart.fill" : "heart"
        
        let button = UIBarButtonItem(
            image: UIImage(systemName: icon),
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
            )
        
        button.tintColor = character.hogwartsHouse.color
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func favoriteTapped() {
        FavoritesManager.shared.toggleFavorite(id: character.index)
        
        let isFav = FavoritesManager.shared.isFavorite(id: character.index)
        let icon = isFav ? "heart.fill" : "heart"
        
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: icon)
    }
}

// MARK: - Custom Label
final class DetailLabel: UILabel {
    init(fontSize: CGFloat, alpha: CGFloat) {
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .regular).withDesign(.serif)
        textColor = UIColor.hpCreamText.withAlphaComponent(alpha)
        textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UIFont Extension
extension UIFont {
    func withDesign(_ design: UIFontDescriptor.SystemDesign) -> UIFont {
        guard let descriptor = self.fontDescriptor.withDesign(design) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}


