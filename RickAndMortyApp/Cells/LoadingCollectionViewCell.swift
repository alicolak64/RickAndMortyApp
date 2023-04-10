//
//  LoadingTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Ali Çolak on 6.04.2023.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {
    static let identifier = "LoadingCollectionViewCell"

    let activityIndicatior: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .gray
        activityIndicator.style = .medium
        return activityIndicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(activityIndicatior)
        activityIndicatior.frame = frame

        activityIndicatior.startAnimating()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
