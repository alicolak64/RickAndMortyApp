//
//  CharacterTableViewCell2.swift
//  RickAndMortyApp
//
//  Created by Ali Çolak on 7.04.2023.
//

import UIKit

class MaleCharacterTableViewCell: UITableViewCell {
    static let identifier = "MaleCharacterTableViewCell"

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let genderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let contentView = self.contentView

        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.masksToBounds = true

        contentView.addSubview(nameLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(genderImageView)

        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.numberOfLines = 0

        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),

            genderImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            genderImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            genderImageView.widthAnchor.constraint(equalToConstant: 70),
            genderImageView.heightAnchor.constraint(equalToConstant: 70),

            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 130),
            avatarImageView.heightAnchor.constraint(equalToConstant: 130),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with character: Character) {
        nameLabel.text = character.name

        if let imageData = character.imageData {
            avatarImageView.image = UIImage(data: imageData)
        }

        switch character.gender {
        case "Male":
            genderImageView.image = UIImage(named: "male")
        case "Genderless":
            genderImageView.image = UIImage(named: "genderless")
        case "Female":
            genderImageView.image = UIImage(named: "female")
        case "unknown":
            genderImageView.image = UIImage(named: "unknown")
        default:
            fatalError("Apı error")
        }
    }
}
