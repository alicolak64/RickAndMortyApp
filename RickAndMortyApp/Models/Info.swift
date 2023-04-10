//
//  Info.swift
//  RickAndMortyApp
//
//  Created by Ali Çolak on 6.04.2023.
//

import Foundation

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
