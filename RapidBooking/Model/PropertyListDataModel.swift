//
//  PropertyListDataModel.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/20/23.
//

import Foundation

struct RapidProperties: Codable{
    let search_id: String?
    let result: [RapidHotel]
}

struct RapidHotel: Codable{
    let address: String?
    let hotel_id: Int?
    let city: String?
    let district: String?
    let zip: String?
    let hotel_name: String?
    let review_score: Double?
    let main_photo_url: String?
    let checkin: HotelCheckIn
    let checkout: HotelCheckOut
}

struct HotelCheckIn: Codable{
    let from: String?
}

struct HotelCheckOut: Codable{
    let until: String?
}
