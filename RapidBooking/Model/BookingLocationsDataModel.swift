//
//  BookingLocationsDataModel.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/18/23.
//

import Foundation

struct RapidLocation: Codable{
    let dest_type: String?
    let hotels: Int?
    let dest_id: String?
    let image_url: String?
    let label: String?
}
