//
//  Show.swift
//  TV Shows
//
//  Created by Infinum on 7/24/22.
//

import Foundation

struct ShowsResponse: Decodable {
    let shows: [Show]
    // let metaData: Meta
}

struct Show: Decodable {
    let id: String
    let title: String
    let averageRating: Double?
    let description: String?
    let imageUrl: String?
    let numberOfReviews: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case averageRating = "average_rating"
        case description
        case imageUrl = "image_url"
        case numberOfReviews = "no_of_reviews"
        case title
    }
}

struct Meta: Decodable {
    let pagination: Pagination
}

struct Pagination: Decodable {
    let page: Int
    let items: Int
}

