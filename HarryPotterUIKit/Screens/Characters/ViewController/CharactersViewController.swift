//
//  HomeViewController.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 16.01.2026.
//

import UIKit
import SnapKit

final class CharactersViewController: BaseViewController {

    // MARK: - Properties
    private var collectionView: UICollectionView!
    private let viewModel = CharactersViewModel()
    private var allCharacters : [CharacterModel] = []
    private var filteredCharacters: [CharacterModel] = []
    private var searchTimer : Timer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme()
        configureSearchBar()
        configureCollectionView()
        loadCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        collectionView.reloadData()
    }
    
    // MARK: - Theme Setup
    private func setupTheme() {
        view.backgroundColor = .hpBackground
        title = "Karakterler"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .hpBackground
        
        // Büyük Başlık
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.hpGold,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold).withDesign(.serif) ?? .systemFont(ofSize: 34)
        ]
        
        // Küçük Başlık
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.hpGold,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold).withDesign(.serif) ?? .systemFont(ofSize: 17)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .hpGold
    }
    
    // MARK: - Async Load
    private func loadCharacters() {
        showLoading()

        Task { [weak self] in
            guard let self = self else { return }

            do {
                let characters = try await viewModel.fetchCharacters()
                self.allCharacters = characters
                self.filteredCharacters = characters
                self.collectionView.reloadData()
                self.hideLoading()
            } catch {
                self.hideLoading()
                self.showError()
            }
        }
    }

    // MARK: - CollectionView Config
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width - 32, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumLineSpacing = 16

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear

        collectionView.register(
            CharacterCell.self,
            forCellWithReuseIdentifier: CharacterCell.reuseIdentifier
        )

        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Search Bar Config
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Karakter Ara"
        searchBar.tintColor = .hpGold
        searchBar.barStyle = .black
        
        let textField = searchBar.searchTextField
        textField.textColor = .hpCreamText
        textField.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        // Placeholder Rengi
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.hpCreamTextSecondary
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "Karakter Ara", attributes: placeholderAttributes)
        
        // Büyüteç İkonu Rengi
        if let glassIconView = textField.leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = .hpGold
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}

// MARK: - CollectionView DataSource & Delegate
extension CharactersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterCell.reuseIdentifier,
            for: indexPath
        ) as? CharacterCell else {
            return UICollectionViewCell()
        }

        let character = filteredCharacters[indexPath.item]
        cell.configure(with: character)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = filteredCharacters[indexPath.item]
        let detailVC = CharacterDetailViewController(character: character)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Search Logic
extension CharactersViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        searchTimer?.invalidate()
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            if searchText.isEmpty {
                self.filteredCharacters = self.allCharacters
            } else {
                self.filteredCharacters = self.allCharacters.filter {
                    $0.fullName.lowercased().contains(searchText.lowercased())
                }
            }
            self.collectionView.reloadData()
        }
    }
}
