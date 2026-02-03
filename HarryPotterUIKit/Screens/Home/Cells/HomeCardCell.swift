//
//  HomeCardCell.swift
//  HarryPotterUIKit
//
//  Created by Ece Akcay on 21.01.2026.
//

import UIKit
import SnapKit

final class HomeCardCell: UICollectionViewCell {

    static let reuseIdentifier = "HomeCardCell"

    private var cardView: HomeCardView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = false
        clipsToBounds = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cardView?.removeFromSuperview()
        cardView = nil
    }

    func configure(
        type: HomeCardView.CardType,
        tapAction: @escaping () -> Void
    ) {
        let view = HomeCardView(type: type, tapAction: tapAction)
        cardView = view

        contentView.addSubview(view)

        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
