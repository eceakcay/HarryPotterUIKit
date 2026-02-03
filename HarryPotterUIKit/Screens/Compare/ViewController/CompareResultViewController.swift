//
//  CompareResultViewController.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 2.02.2026.
//

import UIKit
import SnapKit


final class CompareResultViewController: BaseViewController {
    
    //MARK: - Properties
    private let leftCharacter : CharacterModel
    private let rightCharacter : CharacterModel
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let vsContainer : UIView = {
        let view = UIView()
        view.backgroundColor = .hpGold
        view.layer.cornerRadius = 25
        
        let label = UILabel()
        label.text = "VS"
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.textColor = .black
        
        view.addSubview(label)
        label.snp.makeConstraints { $0.center.equalToSuperview()}
        return view
    }()
    
    private let leftImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 60
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.hpGold.cgColor
        iv.backgroundColor = .gray
        return iv
    }()
    
    private let rightImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 60
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.hpGold.cgColor
        iv.backgroundColor = .gray
        return iv
    }()
    
    private let leftNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .hpCreamText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let rightNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .hpCreamText
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    private let aiCompareButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✨ Ask the Sorting Hat (AI)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 0.45, green: 0.25, blue: 0.65, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 6
        return button
    }()
    
    // MARK: - Init
    init(leftCharacter: CharacterModel, rightCharacter: CharacterModel) {
        self.leftCharacter = leftCharacter
        self.rightCharacter = rightCharacter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Battle Arena"
        setupUI()
        configureData()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview()}
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        contentView.addSubview(leftImageView)
        contentView.addSubview(rightImageView)
        contentView.addSubview(vsContainer)
        contentView.addSubview(leftNameLabel)
        contentView.addSubview(rightNameLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(aiCompareButton)
        
        vsContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        leftImageView.snp.makeConstraints {
            $0.centerY.equalTo(vsContainer)
            $0.trailing.equalTo(vsContainer.snp.leading).offset(-20)
            $0.width.height.equalTo(120)
        }
        
        rightImageView.snp.makeConstraints {
            $0.centerY.equalTo(vsContainer)
            $0.leading.equalTo(vsContainer.snp.trailing).offset(20)
            $0.width.height.equalTo(120)
        }
        
        leftNameLabel.snp.makeConstraints {
            $0.top.equalTo(leftImageView.snp.bottom).offset(12)
            $0.centerX.equalTo(leftImageView)
            $0.width.equalTo(140)
        }
        
        rightNameLabel.snp.makeConstraints {
            $0.top.equalTo(rightImageView.snp.bottom).offset(12)
            $0.centerX.equalTo(rightImageView)
            $0.width.equalTo(140)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(leftNameLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
        }
        
        aiCompareButton.addTarget(self, action: #selector(aiTapped), for: .touchUpInside)
        
        aiCompareButton.snp.makeConstraints {                    $0.top.equalTo(stackView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().offset(-50)
        }
    }
    
    // MARK: - Data Configuration
        private func configureData() {
            if let url = URL(string: leftCharacter.image) { leftImageView.setImage(from: url.absoluteString) }
            if let url = URL(string: rightCharacter.image) { rightImageView.setImage(from: url.absoluteString) }
            
            leftNameLabel.text = leftCharacter.fullName
            rightNameLabel.text = rightCharacter.fullName
            
            leftImageView.layer.borderColor = leftCharacter.hogwartsHouse.color.cgColor
            rightImageView.layer.borderColor = rightCharacter.hogwartsHouse.color.cgColor
            
            
            addComparisonRow(title: "House", keyPath: \.hogwartsHouse.rawValue)
            
            stackView.addArrangedSubview(CompareRowView(
                title: "Species",
                leftValue: leftCharacter.species ?? "-",
                rightValue: rightCharacter.species ?? "-"
            ))
            
            stackView.addArrangedSubview(CompareRowView(
                title: "Ancestry",
                leftValue: leftCharacter.ancestry ?? "-",
                rightValue: rightCharacter.ancestry ?? "-"
            ))
            
            stackView.addArrangedSubview(CompareRowView(
                title: "Patronus",
                leftValue: leftCharacter.patronus ?? "-",
                rightValue: rightCharacter.patronus ?? "-"
            ))
            
            addComparisonRow(title: "Birthdate", keyPath: \.birthdate)
            
            addComparisonRow(title: "Actor", keyPath: \.interpretedBy)
        }
    
    private func addComparisonRow(title: String, keyPath: KeyPath<CharacterModel, String>) {
        let leftVal = leftCharacter[keyPath: keyPath]
        let rightVal = rightCharacter[keyPath: keyPath]
        
        let row = CompareRowView(title: title, leftValue: leftVal, rightValue: rightVal)
        stackView.addArrangedSubview(row)
    }
    
    // MARK: - Actions
    @objc private func aiTapped() {
            let aiVC = CompareAIViewController(left: leftCharacter, right: rightCharacter)

            if let sheet = aiVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            
            present(aiVC, animated: true)
        }
}
