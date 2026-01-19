//
//  HomeViewController.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 16.01.2026.
//

import UIKit
import SnapKit

final class HomeViewController: BaseViewController {

    // MARK: - Properties
    private var collectionView: UICollectionView!
    private let viewModel = HomeViewModel()
    private var allCharacters : [CharacterModel] = [] //tüm veri
    private var filteredCharacters: [CharacterModel] = [] //ekranda gösterilen veri
    private var searchTimer : Timer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Karakterler"
        view.backgroundColor = .systemBackground
        configureSearchBar()
        configureCollectionView()
        loadCharacters()
    }

    //MARK: - ASYNC NASIL ÇAĞRILIYOR?
    private func loadCharacters() {
        showLoading()

        Task { [weak self] in
            guard let self else { return }

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

    // MARK: - CollectionView
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width - 32, height: 70)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground

        collectionView.register(
            HomeCell.self,
            forCellWithReuseIdentifier: HomeCell.reuseIdentifier
        )

        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - search bar kurulumu
    private func configureSearchBar() {
    let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Karakter Ara"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}




extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    //kaç bölüm var
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCharacters.count
    }
    
    //kaç eleman var
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return filteredCharacters.count
    }
    
    //ne gösterilecek
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeCell.reuseIdentifier,
            for: indexPath
        ) as? HomeCell else {
            return UICollectionViewCell()
        }

        let character = filteredCharacters[indexPath.item]
        cell.configure(with: character)
        return cell
    }
    
    //bir cell seçildiğinde
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
        let character = filteredCharacters[indexPath.item]
        let detailVC = CharacterDetailViewController(character: character)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeViewController : UISearchResultsUpdating {
    
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



