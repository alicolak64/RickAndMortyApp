//
//  NetworkManager.swift
//  RickAndMortyApp
//
//  Created by Ali Çolak on 6.04.2023.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()

    private struct Constants {
        static let baseURL = "https://rickandmortyapi.com/api/"
    }

    enum endpoints: String {
        case character
        case location
    }

    private init() {}

    // MARK: - Public

    public func getAllData() {
    }

    public func getLocationData(id: Int, completion: @escaping (Result<Location, Error>) -> Void) {
        print(URL(string: Constants.baseURL + endpoints.location.rawValue + "/\(String(id))") ?? "Printed location url")
        guard let url = URL(string: Constants.baseURL + endpoints.location.rawValue + "/\(String(id))") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let location = try JSONDecoder().decode(Location.self, from: data)

                completion(.success(location))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    public func getLocationsData(page: Int, completion: @escaping (Result<PagedLocation, Error>) -> Void
    ) {
        print(URL(string: Constants.baseURL + endpoints.location.rawValue + "/?page=\(String(page))") ?? "Printed location url")
        guard let url = URL(string: Constants.baseURL + endpoints.location.rawValue + "/?page=\(String(page))") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let locations = try JSONDecoder().decode(PagedLocation.self, from: data)

                completion(.success(locations))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    public func getCharacterInfoForURL(characterURL: String?, completion: @escaping (Result<Character, Error>) -> Void) {
        let group = DispatchGroup()
        if let url = characterURL {
            guard let url = URL(string: url) else { return }
            group.enter()
            let task = URLSession.shared.dataTask(with: url) { data, _, error in

                guard let data = data, error == nil else { return }

                do {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)

                    var character = try decoder.decode(Character.self, from: data)

                    NetworkManager.shared.getCharacterImage(character: character) { data in
                        switch data {
                        case let .success(resultImageData):
                            print("getting character image: \(character.image ?? "")")
                            character.imageData = resultImageData
                            completion(.success(character))
                            group.leave()
                        case let .failure(imageError):
                            print(imageError)
                        }
                    }
                } catch {
                    completion(.failure(error))
                }
            }

            task.resume()
        }
    }

    public func getCharacterImage(character: Character, completion: @escaping (Result<Data, Error>) -> Void
    ) {
        if let imgUrl = character.image {
            guard let url = URL(string: imgUrl) else { return }

            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }

                completion(.success(data))
            }

            task.resume()
        }
    }
}
