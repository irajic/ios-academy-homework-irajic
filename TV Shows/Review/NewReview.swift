//
//  NewReview.swift
//  TV Shows
//
//  Created by Infinum on 7/29/22.
//

import Foundation

struct NewReviewResponse: Decodable {
    let review: NewReview
}

struct NewReview: Decodable {
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
