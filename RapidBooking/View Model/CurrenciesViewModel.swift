//
//  CurrenciesViewModel.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/17/23.
//

import Foundation
import Combine
import SwiftUI

class CurrenciesViewModel: ObservableObject{
    
    @Published var currency: RapidCurrency?
    @Published var hasError: Bool = false
    @Published var error: LoadError?
    @Published private(set) var isLoading = false
    
    private var bag = Set<AnyCancellable>()
    
    func fetchCurrency(){
        let currencyURLString = "https://apidojo-booking-v1.p.rapidapi.com/currency/get-exchange-rates?base_currency=USD"
        let headers = [
            "X-RapidAPI-Key": "54217155a0mshc59ae06a0968327p12a4c1jsn682bd9007ac0",
            "X-RapidAPI-Host": "apidojo-booking-v1.p.rapidapi.com"
        ]
        isLoading = true
        guard let url = URL(string: currencyURLString) else{
            hasError = true
            error = .optionalError
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap({result in
                guard let response = result.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode <= 300 else{
                          throw LoadError.invalidStatus
                      }
                let decoder = JSONDecoder()
                guard let currency = try? decoder.decode(RapidCurrency.self, from: result.data) else{
                    throw LoadError.failedToDecode
                }
                return currency
            })
            .sink(receiveCompletion: {[weak self] result in
                defer{self?.isLoading = false}
                switch result{
                case .failure(let error):
                    self?.hasError = true
                    self?.error = LoadError.custom(error: error)
                default:
                    break
                }
            }, receiveValue: {[weak self] currency in
                self?.currency = currency
            })
            .store(in: &bag)
    }
}

extension CurrenciesViewModel{
    enum LoadError: LocalizedError{
        case custom(error: Error)
        case failedToDecode
        case invalidStatus
        case optionalError
        
        var errorDescription: String?{
            switch self {
            case .custom(let error):
                return error.localizedDescription
            case .failedToDecode:
                return "Failed to decode response."
            case .invalidStatus:
                return "The request failed due to an invalid status range."
            case .optionalError:
                return "Failed to unwrap the optional value."
            }
        }
    }
}
