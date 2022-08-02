//
//  Review.swift
//  TV Shows
//
//  Created by Infinum on 7/27/22.
//

import Foundation

struct ReviewsResponse: Decodable {
    let reviews: [Review]
    let meta: MetaR
}

struct Review: Decodable {
    let id: String
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

struct MetaR: Decodable {
    let pagination: PaginationR
}

struct PaginationR: Decodable {
    let count: Int
    let page: Int
    let items: Int
    let pages: Int
}
