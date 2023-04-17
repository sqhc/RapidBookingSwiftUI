//
//  BookingCurrencyDataModel.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/17/23.
//

import Foundation

struct RapidCurrency: Codable{
    let base_currency_date: String?
}

struct CurrencyRate: Codable{
    let currency: String?
    let exchange_rate_buy: String?
}
