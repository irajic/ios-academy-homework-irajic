//
//  Review.swift
//  TV Shows
//
//  Created by Infinum on 7/27/22.
//

import Foundation

struct ReviewsResponse: Decodable {
    let review: [Review]
}

struct Review: Decodable {
    let id: Int
    let comment: String
    let rating: Int
    let showId: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case rating
        case showId = "show_id"
        case user
    }
}

