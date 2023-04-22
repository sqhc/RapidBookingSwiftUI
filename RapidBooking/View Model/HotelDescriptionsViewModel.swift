//
//  HotelDescriptionsViewModel.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/21/23.
//

import Foundation
import Combine

class HotelDescriptionsViewModel: ObservableObject{
    
    var hotel_id: Int
    var checkInDate: String
    var checkOutDate: String
    
    @Published var descriptions: [HotelDescription]?
    @Published var hasError = false
    @Published var error : LoadError?
    
    private var bag = Set<AnyCancellable>()
    
    init(hotel_id: Int, checkIn: String, checkOut: String){
        self.hotel_id = hotel_id
        self.checkInDate = checkIn
        self.checkOutDate = checkOut
    }
    
    func fetchDescriptions(){
        var searchDescriptionsURLString = "https://apidojo-booking-v1.p.rapidapi.com/properties/get-description?"
        searchDescriptionsURLString += "hotel_ids=\(hotel_id)"
        searchDescriptionsURLString += "&check_out=\(checkOutDate)"
        searchDescriptionsURLString += "&check_in=\(checkInDate)"
        
        let headers = [
            "X-RapidAPI-Key": "54217155a0mshc59ae06a0968327p12a4c1jsn682bd9007ac0",
            "X-RapidAPI-Host": "apidojo-booking-v1.p.rapidapi.com"
        ]
        
        guard let url = URL(string: searchDescriptionsURLString) else{
            hasError = true
            error = .optionalError
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap({ result in
                guard let response = result.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode <= 300 else{
                          throw LoadError.invalidStatus
                      }
                let decoder = JSONDecoder()
                let descriptions = try? decoder.decode([HotelDescription].self, from: result.data)
                return descriptions
            })
            .sink { [weak self] result in
                switch result{
                case .failure(let error):
                    self?.hasError = true
                    self?.error = LoadError.custom(error: error)
                default:
                    break
                }
            } receiveValue: { [weak self] descriptions in
                self?.descriptions = descriptions
            }
            .store(in: &bag)

    }
}

extension HotelDescriptionsViewModel{
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
