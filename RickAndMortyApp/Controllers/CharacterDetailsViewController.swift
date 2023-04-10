//
//  CharacterDetailsViewController.swift
//  RickAndMortyApp
//
//  Created by Ali Çolak on 8.04.2023.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var specyLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var originLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var episodesLabel: UILabel!
    @IBOutlet var createTimeLabel: UILabel!

    var character: Character?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let nonOptinalCharacter = character {
            nameLabel.text = nonOptinalCharacter.name

            if let imageData = nonOptinalCharacter.imageData {
                imageView.image = UIImage(data: imageData)
            }

            statusLabel.text = nonOptinalCharacter.status
            specyLabel.text = nonOptinalCharacter.species
            genderLabel.text = nonOptinalCharacter.gender
            originLabel.text = nonOptinalCharacter.origin.name
            locationLabel.text = nonOptinalCharacter.location.name
            episodesLabel.text = extractEpisodeNumbers(from: nonOptinalCharacter.episode)
            createTimeLabel.text = getDateString(date: nonOptinalCharacter.created)
        }

        // Do any additional setup after loading the view.
    }

    func extractEpisodeNumbers(from episodes: [String?]) -> String {
        let episodeNumbers = episodes.map { $0!.components(separatedBy: "/").last! }
        return episodeNumbers.joined(separator: ",")
    }

    func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy , HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

    @IBAction func clickBackButton(_ sender: Any) {
    }
}
