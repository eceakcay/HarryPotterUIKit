//
//  HomeCell.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 16.01.2026.
//

import UIKit
import SnapKit

class HomeCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "HomeCell"
    
    //MARK: - UIComponents
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let houseLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
// MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(houseLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
    }
    
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with character: HomeCharacter) {
        nameLabel.text = character.name
        houseLabel.text = character.house
    }
}
