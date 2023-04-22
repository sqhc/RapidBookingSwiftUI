//
//  HotelReviewDataModel.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/21/23.
//

import Foundation

struct HotelReviews: Codable{
    let vpm_featured_reviews: [HotelReview]?
    let featured_reviews_title: String?
}

struct HotelReview: Codable{
    let author: ReviewAuthor?
    let travel_purpose: String?
    let pros: String?
    let title: String?
    let id: Int?
    let cons: String?
    let average_score_out_of_10: Double?
    let date: String?
}

struct ReviewAuthor: Codable{
    let name: String?
}
