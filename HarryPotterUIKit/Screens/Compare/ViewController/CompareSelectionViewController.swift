//
//  CompareSelectionViewController.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 2.02.2026.
//

import UIKit
import SnapKit

final class CompareSelectionViewController: BaseViewController {
    
    // MARK: - Properties
    private var collectionView: UICollectionView!
    private let viewModel = CompareSelectionViewModel()
    
    private var characters: [CharacterModel] = []
    private var selectedCharacters: [CharacterModel] = []
    
    // MARK: - UI Elements
    private lazy var compareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Compare Wizards (0/2)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .hpGold
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 14
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 6
        
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Compare Wizards"
        
        configureCollectionView()
        setupCompareButton()
        loadCharacters()
    }
    
    // MARK: - Data Loading
    private func loadCharacters() {
        showLoading()
        Task {
            do {
                let fetched = try await viewModel.fetchCharacters()
                await MainActor.run {
                    self.characters = fetched
                    self.collectionView.reloadData()
                    self.hideLoading()
                }
            } catch {
                await MainActor.run {
                    self.hideLoading()
                    self.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - UI Setup
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 32
        layout.itemSize = CGSize(width: width, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        // Çoklu seçimi açıyoruz
        collectionView.allowsMultipleSelection = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    private func setupCompareButton() {
        view.addSubview(compareButton)
        compareButton.addTarget(self, action: #selector(compareTapped), for: .touchUpInside)
        
        compareButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(56)
        }
    }
    
    // MARK: - Logic
    private func updateCompareButton() {
        let count = selectedCharacters.count
        let isReady = count == 2
        
        compareButton.setTitle("Compare Wizards (\(count)/2)", for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.compareButton.isEnabled = isReady
            self.compareButton.alpha = isReady ? 1.0 : 0.5
            self.compareButton.transform = isReady ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
        }
    }
    
    @objc private func compareTapped() {
        guard selectedCharacters.count == 2 else { return }
        
         let resultVC = CompareResultViewController(leftCharacter: selectedCharacters[0], rightCharacter: selectedCharacters[1])
         navigationController?.pushViewController(resultVC, animated: true)
        
        print("⚔️ Kıyaslama Başlıyor: \(selectedCharacters[0].fullName) vs \(selectedCharacters[1].fullName)")
    }
}

// MARK: - CollectionView DataSource & Delegate
extension CompareSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as! CharacterCell
        cell.configure(with: characters[indexPath.item])
        return cell
    }
    
    // Hücre Seçilince
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCharacters.count >= 2 {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        let selected = characters[indexPath.item]
        selectedCharacters.append(selected)
        updateCompareButton()
    }
    
    // Hücre Seçimi Kaldırılınca
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let deselected = characters[indexPath.item]
        selectedCharacters.removeAll { $0.index == deselected.index }
        updateCompareButton()
    }
}
