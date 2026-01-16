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
    private var characters: [HomeCharacter] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Characters"
        view.backgroundColor = .systemBackground

        characters = viewModel.fetchCharacters()
        configureCollectionView()
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
}

extension HomeViewController: UICollectionViewDataSource {

    //kaç bölüm var
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //kaç eleman var
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return characters.count
    }
    
    //ne gösterilecek
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeCell.reuseIdentifier,
            for: indexPath
        ) as? HomeCell else {
            return UICollectionViewCell()
        }

        let character = characters[indexPath.item]
        cell.configure(with: character)
        return cell
    }
}

//bir cell seçildiğinde
extension HomeViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let character = characters[indexPath.item]
        print("Seçilen karakter:", character.name)
    }
}

