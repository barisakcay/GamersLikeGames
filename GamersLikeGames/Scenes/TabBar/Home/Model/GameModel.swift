//
//  GameModel.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 21.05.2024.
//

import Foundation

struct GameModel: Decodable {
    
    let nextPage: String?
    let previousPage: String?
    let results: [Games]
    
    enum CodingKeys: String, CodingKey {
        case results
        case nextPage = "next"
        case previousPage = "previous"
    }
}

struct Games: Decodable {
    let id: Int?
    let name: String?
    let released: String?
    let rating: Float?
    let backgroundImage: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, released, rating
        case backgroundImage = "background_image"
    }
}
