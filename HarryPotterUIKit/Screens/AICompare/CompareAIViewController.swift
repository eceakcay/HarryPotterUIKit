//
//  CompareAIViewController.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 2.02.2026.
//

import UIKit
import SnapKit

final class CompareAIViewController: BaseViewController {

    private let left: CharacterModel
    private let right: CharacterModel

    // MARK: - UI Elements
    
    // 1. Ana Başlık
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "✨ The Sorting Hat Speaks"
        label.font = .systemFont(ofSize: 22, weight: .bold).withDesign(.serif)
        label.textColor = .hpGold
        label.textAlignment = .center
        return label
    }()

    // 2. Sonuç Kartı (Kırmızı arka plan, altın çerçeve)
    private let resultCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .hpCardBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.hpGold.withAlphaComponent(0.6).cgColor
        
        // Gölge
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        
        view.alpha = 0
        return view
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()

    private let winnerBadgeLabel: UILabel = {
        let label = UILabel()
        label.text = "🏆 WINNER"
        label.font = .systemFont(ofSize: 12, weight: .heavy)
        label.textColor = .black
        label.backgroundColor = .hpGold
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.textAlignment = .center
        return label
    }()
    
    private let winnerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold).withDesign(.serif)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.shadowColor = UIColor.hpGold.cgColor
        label.layer.shadowRadius = 10
        label.layer.shadowOpacity = 0.5
        label.layer.shadowOffset = .zero
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hpGold.withAlphaComponent(0.3)
        return view
    }()
    
    private let reasonTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "📜 The Verdict"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .hpGold
        return label
    }()
    
    private let reasonTextLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 16)
        label.textColor = .hpCreamText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let thinkingStack: UIStackView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.color = .hpGold

        let label = UILabel()
        label.text = "🧙‍♂️ Sorting Hat is thinking..."
        label.font = .systemFont(ofSize: 16, weight: .medium).withDesign(.serif)
        label.textColor = .hpCreamText
        label.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [spinner, label])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()


    // MARK: - Init
    init(left: CharacterModel, right: CharacterModel) {
        self.left = left
        self.right = right
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hpBackground
        setupUI()
        runAIComparison()
        resultCardView.isHidden = true
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(resultCardView)
        view.addSubview(thinkingStack)
        
        resultCardView.addSubview(contentStack)
        
        contentStack.addArrangedSubview(winnerBadgeLabel)
        contentStack.addArrangedSubview(winnerNameLabel)
        contentStack.addArrangedSubview(dividerView)
        contentStack.addArrangedSubview(reasonTitleLabel)
        contentStack.addArrangedSubview(reasonTextLabel)
        
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        resultCardView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview().offset(-40)
        }
        
        contentStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(24)
        }
        
        winnerBadgeLabel.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(24)
        }
        
        dividerView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(100)
        }
        
        thinkingStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

    }

    // MARK: - AI Logic
    private func runAIComparison() {
        showLoading()

        Task {
            do {
                let result = try await AIService.shared.compareCharacters(
                    left: left,
                    right: right
                )

                await MainActor.run {
                    self.hideLoading()
                    self.showResult(result)
                }

            } catch {
                await MainActor.run {
                    self.hideLoading()
                    self.showErrorState(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showResult(_ result: AICompareResult) {
        thinkingStack.removeFromSuperview()

        updateUI(with: result)

        resultCardView.isHidden = false
        resultCardView.alpha = 0
        resultCardView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)

        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.6
        ) {
            self.resultCardView.alpha = 1
            self.resultCardView.transform = .identity
        }
    }

    
    private func updateUI(with result: AICompareResult) {
        winnerNameLabel.text = result.winner
        reasonTextLabel.text = "\"\(result.reason)\""

        let glowColor: UIColor
        if result.winner == left.fullName {
            glowColor = left.hogwartsHouse.color
        } else {
            glowColor = right.hogwartsHouse.color
        }

        resultCardView.layer.shadowColor = glowColor.cgColor
        resultCardView.layer.shadowRadius = 20
        resultCardView.layer.shadowOpacity = 0.8
        resultCardView.layer.shadowOffset = .zero
    }

    
    private func showErrorState(message: String) {
        winnerNameLabel.text = "Connection Severed"
        winnerNameLabel.textColor = .systemRed
        reasonTextLabel.text = message
        winnerBadgeLabel.isHidden = true
        
        UIView.animate(withDuration: 0.3) {
            self.resultCardView.alpha = 1
        }
    }
}
