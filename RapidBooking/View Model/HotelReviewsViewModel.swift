//
//  HotelReviewsViewModel.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/21/23.
//

import Foundation
import Combine

class HotelReviewsViewModel: ObservableObject{
    
    var hotel_id: Int
    
    @Published var reviews: HotelReviews?
    @Published var hasError = false
    @Published var error : LoadError?
    
    private var bag = Set<AnyCancellable>()
    
    init(hotel_id: Int){
        self.hotel_id = hotel_id
    }
    
    func fetchReviews(){
        var searchReviewsURLString = "https://apidojo-booking-v1.p.rapidapi.com/properties/get-featured-reviews?"
        searchReviewsURLString += "hotel_id=\(hotel_id)"
        
        let headers = [
            "X-RapidAPI-Key": "54217155a0mshc59ae06a0968327p12a4c1jsn682bd9007ac0",
            "X-RapidAPI-Host": "apidojo-booking-v1.p.rapidapi.com"
        ]
        
        guard let url = URL(string: searchReviewsURLString) else{
            hasError = true
            error = .optionalError
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap({result in
                guard let response = result.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode <= 300 else{
                          throw LoadError.invalidStatus
                      }
                let decoder = JSONDecoder()
                let reviews = try? decoder.decode(HotelReviews.self, from: result.data)
                return reviews
            })
            .sink { [weak self] result in
                switch result{
                case .failure(let error):
                    self?.hasError = true
                    self?.error = LoadError.custom(error: error)
                default:
                    break
                }
            } receiveValue: { [weak self] reviews in
                self?.reviews = reviews
            }
            .store(in: &bag)

    }
}

extension HotelReviewsViewModel{
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
