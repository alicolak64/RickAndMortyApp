//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Ali Çolak on 6.04.2023.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let status: String?
    let species: String?
    let gender: String?
    let origin: CharLocation
    let location: CharLocation
    let episode: [String?]
    let image: String?
    let url: String?
    var imageData: Data?
    let created: Date
}

struct CharLocation: Codable {
    let name: String
    let url: String
}
