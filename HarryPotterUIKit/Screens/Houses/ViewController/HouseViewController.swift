//
//  HouseViewController.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 30.01.2026.
//

import UIKit
import SnapKit

final class HouseViewController: BaseViewController { // BaseVC'den türettik
    
    private var collectionView: UICollectionView!
    private var houses: [House] = []
    
    // ViewModel'i kullanacağız
    private let viewModel = HousesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hpBackground
        title = "Houses"
        
        configureCollectionView()
        loadHouses()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        // Delegate ve DataSource bağlantıları
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(HouseCell.self, forCellWithReuseIdentifier: HouseCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func loadHouses() {
        showLoading() // BaseVC'den geliyor (Garson güvenli)
        
        Task {
            do {
                // 1. İşi ViewModel'e devrediyoruz (Aşçı çalışıyor)
                let fetchedHouses = try await viewModel.fetchHouses()
                
                // 2. Servis için Garsonu çağırıyoruz (Main Thread)
                await MainActor.run {
                    self.houses = fetchedHouses
                    self.collectionView.reloadData()
                    self.hideLoading()
                }
            } catch {
                // Hata durumunda da Garsonu çağırıyoruz
                await MainActor.run {
                    self.hideLoading()
                    self.showError(message: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - CollectionView DataSource & DelegateFlowLayout
extension HouseViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return houses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HouseCell.reuseIdentifier, for: indexPath) as! HouseCell
        cell.configure(with: houses[indexPath.item])
        return cell
    }
    
    // Hücre boyutlarını dinamik hesaplamak her zaman daha iyidir
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Ekran genişliğinden kenar boşluklarını (16 sol + 16 sağ + 16 orta = 48) çıkarıp 2'ye bölüyoruz
        let width = (collectionView.bounds.width - 48) / 2
        return CGSize(width: width, height: 160)
    }
}
