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
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    private let houseLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    private let actorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    private let birthdateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    private let childrenLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
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
        title = "Detay"
        view.backgroundColor = .systemBackground

        setupUI()
        bindData()
    }

    // MARK: - Setup UI
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [
            nameLabel,
            nicknameLabel,
            houseLabel,
            actorLabel,
            birthdateLabel,
            childrenLabel
        ])

        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center

        view.addSubview(stack)

        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }

    // MARK: - Bind Data
    private func bindData() {
        let detailData = viewModel.makeDetailData(from: character)

        nameLabel.text = detailData.fullName
        nicknameLabel.text = "Nickname: \(detailData.nickname)"
        houseLabel.text = "House: \(detailData.house)"
        actorLabel.text = "Actor: \(detailData.actor)"
        birthdateLabel.text = "Born: \(detailData.birthdate)"
        childrenLabel.text = "Children: \(detailData.childrenText)"
    }
}
