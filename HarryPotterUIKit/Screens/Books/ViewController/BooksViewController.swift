//
//  BooksViewController.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 21.01.2026.
//

import UIKit
import SnapKit

final class BooksViewController: BaseViewController {
    
    private let viewModel = BooksViewModel()
    private var books : [Book] = []
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hpBackground
        title = "Books"
        configureCollectionView()
        loadBooks()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width - 32,
            height: 120
        )
        
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.reuseIdentifier)
        
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func loadBooks() {
        showLoading()
        Task {
            do {
                let fetchedBooks = try await viewModel.fetchBooks()
                await MainActor.run {
                    // Yükleme bitti, gizle
                    self.hideLoading()
                    self.books = fetchedBooks
                    self.collectionView.reloadData()
                }
            } catch {
                await MainActor.run {
                    // Hata durumunda hem loading gizle hem hata göster
                    self.hideLoading()
                    self.showError(message: error.localizedDescription)
                }
            }
        }
    }
}

extension BooksViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.reuseIdentifier, for: indexPath
        ) as! BookCell
        
        cell.configure(with: books[indexPath.item])
        return cell 
    }
    
    
}
