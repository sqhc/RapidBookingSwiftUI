//
//  LocationsViewModel.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/19/23.
//

import Foundation
import Combine

class LocationsViewModel: ObservableObject{
    @Published var location : String
    @Published var locations: [RapidLocation] = []
    @Published var hasError = false
    @Published var error : LoadError?
    @Published private(set) var isLoading = false
    
    private var bag = Set<AnyCancellable>()
    
    init(location: String){
        self.location = location
    }
    
    func fetchLocations(){
        var locationsURLString = "https://apidojo-booking-v1.p.rapidapi.com/locations/auto-complete?text="
        locationsURLString += location
        
        let headers = [
            "X-RapidAPI-Key": "54217155a0mshc59ae06a0968327p12a4c1jsn682bd9007ac0",
            "X-RapidAPI-Host": "apidojo-booking-v1.p.rapidapi.com"
        ]
        
        guard let url = URL(string: locationsURLString) else{
            hasError = true
            error = .optionalError
            return 
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap({ result in
                guard let response = result.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode <= 300 else{
                          throw LoadError.invalidStatus
                      }
                let decoder = JSONDecoder()
                guard let locations = try? decoder.decode([RapidLocation].self, from: result.data) else{
                    throw LoadError.failedToDecode
                }
                return locations
            })
            .sink(receiveCompletion: {[weak self] result in
                switch result{
                case .failure(let error):
                    self?.hasError = true
                    self?.error = LoadError.custom(error: error)
                default:
                    break
                }
            }, receiveValue: {[weak self] locations in
                self?.locations = locations
            })
            .store(in: &bag)
    }
}

extension LocationsViewModel{
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
