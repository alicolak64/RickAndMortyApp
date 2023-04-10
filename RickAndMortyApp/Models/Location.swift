//
//  Location.swift
//  RickAndMortyApp
//
//  Created by Ali Çolak on 6.04.2023.
//

import Foundation

struct PagedLocation: Codable {
    let info: Info
    let results: [Location]
}

struct Location: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
}
