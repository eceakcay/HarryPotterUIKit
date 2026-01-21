//
//  HomeCardView.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 21.01.2026.
//

import UIKit
import SnapKit

final class HomeCardView: UIView {
    
    enum CardType {
        case characters
        case books
        case houses
        
        var title: String {
            switch self {
            case .characters: return "Characters"
            case .books: return "Books"
            case .houses: return "Houses"
            }
        }
        
        var icon: String {
            switch self {
            case .characters: return "person.3.fill"
            case .books: return "book.closed.fill"
            case .houses: return "building.columns.fill"
            }
        }
    }
    
    private let type: CardType
    private let tapAction: () -> Void
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .hpCardBackground
        view.layer.cornerRadius = 20
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.hpGold.withAlphaComponent(0.4).cgColor
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .hpGold
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium).withDesign(.serif)
        label.textColor = .hpCreamText
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    // MARK: - Init
    init(type: CardType, tapAction: @escaping () -> Void) {
        self.type = type
        self.tapAction = tapAction
        super.init(frame: .zero)
        setupUI()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        iconImageView.image = UIImage(systemName: type.icon)
        iconImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-12)
            $0.width.height.equalTo(30)
        }
        
        titleLabel.text = type.title
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(4)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.containerView.backgroundColor = UIColor.hpGold.withAlphaComponent(0.2)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
                self.containerView.backgroundColor = .hpCardBackground
            } completion: { _ in
                self.tapAction()
            }
        }
    }
}
