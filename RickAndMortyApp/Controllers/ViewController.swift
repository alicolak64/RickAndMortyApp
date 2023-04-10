//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by Ali Çolak on 6.04.2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var locationCollectionView: UICollectionView!
    @IBOutlet var charactertableView: UITableView!

    var page: Int = 1
    var locations: [Location?] = [] {
        didSet {
            DispatchQueue.main.async {
                self.locationCollectionView.reloadData()
            }
        }
    }

    var activeLocation: Location?

    var residents: [Character?] = [] {
        didSet {
            let sortedResidents = residents.sorted { $0!.id < $1!.id }
            residents = sortedResidents
            DispatchQueue.main.async {
                self.charactertableView.reloadData()
            }
        }
    }

    var selectedCharacter: Character?

    override func viewDidLoad() {
        super.viewDidLoad()

        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
        locationCollectionView.register(LocationCollectionViewCell.self, forCellWithReuseIdentifier: LocationCollectionViewCell.identifier)
        locationCollectionView.register(LoadingCollectionViewCell.self, forCellWithReuseIdentifier: LoadingCollectionViewCell.identifier)
        locationCollectionView.clipsToBounds = true

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        locationCollectionView.collectionViewLayout = layout

        charactertableView.delegate = self
        charactertableView.dataSource = self
        charactertableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.identifier)
        charactertableView.register(FemaleCharacterTableViewCell.self, forCellReuseIdentifier: FemaleCharacterTableViewCell.identifier)
        charactertableView.register(MaleCharacterTableViewCell.self, forCellReuseIdentifier: MaleCharacterTableViewCell.identifier)
        charactertableView.clipsToBounds = true
        getDefaultLocation()
    }

    override func viewDidLayoutSubviews() {
        locationCollectionView.contentSize = CGSize(width: locationCollectionView.contentSize.width, height: locationCollectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == locations.count {
            guard let cell = locationCollectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.identifier, for: indexPath) as? LoadingCollectionViewCell else {
                fatalError()
            }

            NetworkManager.shared.getLocationsData(page: page) { result in
                switch result {
                case let .success(models):

                    for result in models.results {
                        self.locations.append(result)
                    }
                    self.page += 1

                case let .failure(error):
                    print(error)
                    DispatchQueue.main.async {
                        cell.isHidden = true
                    }
                }
            }

            return cell
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.identifier, for: indexPath) as? LocationCollectionViewCell else {
            fatalError()
        }

        if locations[indexPath.row]!.id == activeLocation?.id {
            cell.backgroundColor = .gray
        } else {
            cell.backgroundColor = .white
        }
        cell.configure(with: locations[indexPath.row]!)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let activeLocationIndexPath = getIndexPath(forLocation: activeLocation!),
           let activeCell = collectionView.cellForItem(at: activeLocationIndexPath) {
            activeCell.backgroundColor = .white
        }

        if let location = locations[indexPath.row] {
            activeLocation = location
            getCharactersInLocation(forLocation: location)
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = .gray
        }
    }

    func getIndexPath(forLocation location: Location) -> IndexPath? {
        if let index = locations.firstIndex(where: { $0!.name == location.name }) {
            return IndexPath(item: index, section: 0)
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return residents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gender = residents[indexPath.row]!.gender

        if gender == "Female" || gender == "unknown" {
            guard let cell = charactertableView.dequeueReusableCell(withIdentifier: FemaleCharacterTableViewCell.identifier, for: indexPath) as? FemaleCharacterTableViewCell else {
                fatalError()
            }
            cell.configure(with: residents[indexPath.row]!)
            return cell
        } else {
            guard let cell = charactertableView.dequeueReusableCell(withIdentifier: MaleCharacterTableViewCell.identifier, for: indexPath) as? MaleCharacterTableViewCell else {
                fatalError()
            }
            cell.configure(with: residents[indexPath.row]!)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let character = residents[indexPath.row] {
            selectedCharacter = character
            UserDefaults.standard.set(activeLocation?.id, forKey: "lastLocation")
            performSegue(withIdentifier: "OpenCharacterDetail", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenCharacterDetail" {
            let destinationVC = segue.destination as! CharacterDetailsViewController
            destinationVC.character = selectedCharacter
        }
    }

    func getCharactersInLocation(forLocation location: Location) {
        residents.removeAll()
        for url in location.residents {
            if location.id == activeLocation?.id {
                NetworkManager.shared.getCharacterInfoForURL(characterURL: url) { data in
                    switch data {
                    case let .success(model):
                        let hasCharacter = self.residents.contains { character in
                            character!.id == model.id
                        }
                        if model.location.name == self.activeLocation?.name && !hasCharacter {
                            self.residents.append(model)
                        }
                    case let .failure(error):
                        print("getEpisodeData fail")
                        print(error)
                    }
                }
            }
        }
        residents = residents.sorted { $0!.id < $1!.id }
    }

    func getDefaultLocation() {
        var storedLocationId = UserDefaults.standard.object(forKey: "lastLocation") as? Int

        if storedLocationId == nil || storedLocationId! > 20 {
            storedLocationId = 1
        }

        NetworkManager.shared.getLocationData(id: storedLocationId!) { result in
            switch result {
            case let .success(location):
                self.activeLocation = location
                self.getCharactersInLocation(forLocation: self.activeLocation!)
            case let .failure(error):
                print("Error getting location: \(error)")
            }
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 130 // collection view'ın genişliği
        let height: CGFloat = 50 // hücrelerin yüksekliği

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Yatay boşluklar
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Dikey boşluklar
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 // hücre yüksekliği
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10 // Hücreler arasındaki boşluğun boyutu
    }
}
