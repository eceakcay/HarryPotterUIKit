//
//  FavoritesViewController.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 21.01.2026.
//

import UIKit
import SnapKit

final class FavoritesViewController: BaseViewController {
    
    private var collectionView: UICollectionView!
    
    // ViewModel Tanımlaması
    private let viewModel = FavoritesViewModel()
    
    // Ekranda gösterilecek filtrelenmiş liste
    private var favoriteCharacters: [CharacterModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        
        configureCollectionView()
        // viewDidLoad'da çağırmamıza gerek yok, viewWillAppear her seferinde halledecek.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    private func configureCollectionView() {
        // ... (Burası aynı kalıyor) ...
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 32
        layout.itemSize = CGSize(width: width, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func loadFavorites() {
        showLoading()
        
        Task {
            do {
                // ARTIK NETWORK YOK -> ViewModel VAR
                // ViewModel bize hazır filtrelenmiş veriyi verir
                let favorites = try await viewModel.fetchFavorites()
                
                await MainActor.run {
                    self.favoriteCharacters = favorites
                    self.collectionView.reloadData()
                    self.hideLoading()
                    
                    // Liste boşsa kullanıcıya bilgi verilebilir (Opsiyonel)
                    if self.favoriteCharacters.isEmpty {
                        // showEmptyState()
                    }
                }
            } catch {
                await MainActor.run {
                    self.hideLoading()
                    print("Favoriler yüklenirken hata: \(error)")
                }
            }
        }
    }
}

// MARK: - CollectionView DataSource & Delegate
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as! CharacterCell
        
        let character = favoriteCharacters[indexPath.item]
        cell.configure(with: character)
        
        // Favoriden çıkarma işlemi
        cell.onFavoriteTapped = { [weak self] in
            guard let self = self else { return }
            
            // 1. Manager'dan sil
            FavoritesManager.shared.toggleFavorite(id: character.index)
            
            // 2. Listeyi Yenile (ViewModel tekrar filtreleyip getirecek)
            self.loadFavorites()
        }
        
        return cell
    }
}
