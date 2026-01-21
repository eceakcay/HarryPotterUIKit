//
//  HomeViewController.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 21.01.2026.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {

    private enum Section: Int, CaseIterable {
        case header
        case content
    }

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hpBackground
        
        // Navigation Bar'ı gizle (Custom Header kullanıyoruz)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        configureCollectionView()
    }

    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20) // Kenar boşlukları 16'dan 20'ye çıktı

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            HomeHeaderCell.self,
            forCellWithReuseIdentifier: HomeHeaderCell.reuseIdentifier
        )

        collectionView.register(
            HomeCardCell.self,
            forCellWithReuseIdentifier: HomeCardCell.reuseIdentifier
        )

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else { return 0 }

        switch section {
        case .header: return 1
        case .content: return 3
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let section = Section(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }

        switch section {
        case .header:
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeHeaderCell.reuseIdentifier,
                for: indexPath
            )

        case .content:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCardCell.reuseIdentifier,
                for: indexPath
            ) as! HomeCardCell

            let type: HomeCardView.CardType

            switch indexPath.item {
            case 0: type = .characters
            case 1: type = .books
            default: type = .houses
            }

            cell.configure(type: type) { [weak self] in
                self?.handleCardTap(type)
            }

            return cell
        }
    }
    
    private func handleCardTap(_ type: HomeCardView.CardType) {
        // Detay sayfasına giderken Nav Bar geri gelsin
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        switch type {
        case .characters:
            navigationController?.pushViewController(CharactersViewController(), animated: true)
            print("Characters tapped")
        case .books:
            print("Books tapped")
        case .houses:
            print("Houses tapped")
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:IndexPath) -> CGSize {

        guard let section = Section(rawValue: indexPath.section) else {
            return .zero
        }

        let width = collectionView.bounds.width

        switch section {

        case .header:
            // Header yüksekliği: Resim + Yazılar için ideal alan
            return CGSize(
                width: width,
                height: 340
            )

        case .content:
            // Kart Genişlik Hesabı:
            // (Ekran - (Sol 20 + Sağ 20 + Ara 12 + Ara 12)) / 3
            let totalSpacing: CGFloat = 40 + 24
            let availableWidth = width - totalSpacing
            let cardWidth = availableWidth / 3

            return CGSize(
                width: cardWidth,
                height: 125 // Yükseklik 140'tan 125'e indi (Daha kare, daha şık)
            )
        }
    }
}
