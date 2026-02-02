//
//  CompareRowView.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 2.02.2026.
//

import SnapKit
import UIKit

final class CompareRowView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .hpGold
        label.textAlignment = .center
        label.text = "ATTRIBUTE"
        return label
    }()
    
    private let leftValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .hpCreamText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let rightValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .hpCreamText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hpGold.withAlphaComponent(0.2)
        return view
    }()
    
    init(title: String, leftValue: String, rightValue: String) {
        super.init(frame: .zero)
        setupUI()
        titleLabel.text = title.uppercased()
        leftValueLabel.text = leftValue.isEmpty ? "-" : leftValue
        rightValueLabel.text = rightValue.isEmpty ? "-" : rightValue
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(leftValueLabel)
        addSubview(rightValueLabel)
        addSubview(separator)
        
        // Ortadaki Başlık
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
        }
        
        // Sol Değer
        leftValueLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(snp.centerX).offset(-8)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        // Sağ Değer
        rightValueLabel.snp.makeConstraints {
            $0.top.equalTo(leftValueLabel)
            $0.leading.equalTo(snp.centerX).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        // Çizgi
        separator.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
