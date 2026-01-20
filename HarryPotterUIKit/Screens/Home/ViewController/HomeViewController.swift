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
    private var allCharacters : [CharacterModel] = [] // tüm veri
    private var filteredCharacters: [CharacterModel] = [] // ekranda gösterilen veri
    private var searchTimer : Timer?
    
    // Tematik Renkler
    private let darkBackground = UIColor(red: 0.05, green: 0.07, blue: 0.12, alpha: 1.0) // Gece Mavisi
    private let goldColor = UIColor(red: 0.85, green: 0.75, blue: 0.45, alpha: 1.0)      // Altın Sarısı
    private let creamText = UIColor(red: 0.96, green: 0.93, blue: 0.86, alpha: 1.0)      // Parşömen
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme() // Temayı uygula
        configureSearchBar()
        configureCollectionView()
        loadCharacters()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ekran her göründüğünde Büyük Başlığı zorla açıyoruz
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        }
    
    
    // MARK: - Theme Setup
    private func setupTheme() {
            view.backgroundColor = darkBackground
            title = "Karakterler"
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground() // Arka planı opak (dolu) yap
            appearance.backgroundColor = darkBackground
            
            // Büyük Başlık Fontu & Rengi
            appearance.largeTitleTextAttributes = [
                .foregroundColor: goldColor,
                .font: UIFont.systemFont(ofSize: 34, weight: .bold).withDesign(.serif) ?? .systemFont(ofSize: 34)
            ]
            
            // Küçük Başlık Fontu & Rengi (Kaydırınca çıkan)
            appearance.titleTextAttributes = [
                .foregroundColor: goldColor,
                .font: UIFont.systemFont(ofSize: 17, weight: .semibold).withDesign(.serif) ?? .systemFont(ofSize: 17)
            ]
            
            // ⚠️ EN ÖNEMLİ KISIM: Tüm durumlara aynı ayarı ata
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.tintColor = goldColor
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
                self.showError() // BaseVC'den gelen hata gösterimi
            }
        }
    }

    // MARK: - CollectionView Config
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width - 32, height: 80) // Biraz daha yüksek yaptık
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        // Kartlar arası dikey boşluk
        layout.minimumLineSpacing = 16

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear // Arka plan rengi gözüksün diye clear yaptık

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
    
    // MARK: - Search Bar Config
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        // Search Bar Metin Rengi Ayarları
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Karakter Ara"
        searchBar.tintColor = goldColor // "Cancel" butonu rengi
        searchBar.barStyle = .black // Koyu tema için (içindeki text beyaz olur)
        
        // TextField içindeki yazıyı krem rengi yapalım
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = creamText
            textField.backgroundColor = UIColor(white: 1, alpha: 0.1) // Hafif şeffaf arka plan
            
            // Placeholder rengi
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: creamText.withAlphaComponent(0.6)
            ]
            textField.attributedPlaceholder = NSAttributedString(string: "Karakter Ara", attributes: placeholderAttributes)
            
            // Büyüteç ikonu rengi
            if let glassIconView = textField.leftView as? UIImageView {
                glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                glassIconView.tintColor = goldColor
            }
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}

// MARK: - CollectionView DataSource & Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Bölüm içindeki eleman sayısı karakter sayısı kadar olmalı
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCharacters.count
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = filteredCharacters[indexPath.item]
        let detailVC = CharacterDetailViewController(character: character)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Search Logic
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
                    // name yerine fullName kullanıyordun, onu korudum
                    $0.fullName.lowercased().contains(searchText.lowercased())
                }
            }
            self.collectionView.reloadData()
        }
    }
}
