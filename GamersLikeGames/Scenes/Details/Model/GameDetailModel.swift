//
//  GameDetailModel.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 24.05.2024.
//

import Foundation

struct GameDetailModel: Decodable {
    let name: String?
    let released: String?
    let description: String?
    let metacritic: Int?
    let backgroundImage: String?
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case name, released, description, metacritic,id
        case backgroundImage = "background_image"
    }
}
