//
//  HouseCell.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 30.01.2026.
//

import UIKit
import SnapKit

final class HouseCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "HouseCell"
    
    private let container : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 6
        return view
    }()
    
    private let emojiLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40)
        label.textAlignment = .center
        return label
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold).withDesign(.serif)
        label.textAlignment = .center
        label.textColor = .hpCreamText
        return label
    }()
    
    private let founderLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .hpCreamTextSecondary
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(container)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(founderLabel)
        
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emojiLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(emojiLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        
        founderLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    func configure(with house: House) {
        nameLabel.text = house.house
        founderLabel.text = house.founder
        emojiLabel.text = house.emoji
        
        let accent = house.houseColor
        container.backgroundColor = accent.withAlphaComponent(0.85)
    }
}

extension House {
    var houseColor: UIColor {
        switch house {
        case "Gryffindor":
            return HogwartsHouse.gryffindor.color
        case "Slytherin":
            return HogwartsHouse.slytherin.color
        case "Ravenclaw":
            return HogwartsHouse.ravenclaw.color
        case "Hufflepuff":
            return HogwartsHouse.hufflepuff.color
        default:
            return .hpCardBackground
        }
    }
}

