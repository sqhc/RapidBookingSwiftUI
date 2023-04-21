//
//  PropertiesViewModel.swift
//  RapidBooking
//
//  Created by 沈清昊 on 4/20/23.
//

import Foundation
import Combine

class PropertiesViewModel: ObservableObject{
    
    var arrivalDate: String
    var departureDate: String
    var guestQty: String
    var roomQty: String
    var dest_id: String
    var search_type: String
    
    @Published var properties: RapidProperties?
    @Published var hasError = false
    @Published var error : LoadError?
    
    private var bag = Set<AnyCancellable>()
    
    init(arrivalDate: String, departureDate: String, guestQty: String, roomQty: String, dest_id: String, search_type: String){
        self.arrivalDate = arrivalDate
        self.departureDate = departureDate
        self.guestQty = guestQty
        self.roomQty = roomQty
        self.dest_id = dest_id
        self.search_type = search_type
    }
    
    func fetchProperties(){
        var propertiesURLString = "https://apidojo-booking-v1.p.rapidapi.com/properties/list?offset=0"
        propertiesURLString += "&arrival_date=\(arrivalDate)"
        propertiesURLString += "&departure_date=\(departureDate)"
        propertiesURLString += "&guest_qty=\(guestQty)"
        propertiesURLString += "&dest_ids=\(dest_id)"
        propertiesURLString += "&room_qty=\(roomQty)"
        propertiesURLString += "&search_type=\(search_type)"
        
        let headers = [
            "X-RapidAPI-Key": "54217155a0mshc59ae06a0968327p12a4c1jsn682bd9007ac0",
            "X-RapidAPI-Host": "apidojo-booking-v1.p.rapidapi.com"
        ]
        
        guard let url = URL(string: propertiesURLString) else{
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
                guard let properties = try? decoder.decode(RapidProperties.self, from: result.data) else{
                    throw LoadError.failedToDecode
                }
                return properties
            })
            .sink { [weak self] result in
                switch result{
                case .failure(let error):
                    self?.hasError = true
                    self?.error = LoadError.custom(error: error)
                default:
                    break
                }
            } receiveValue: { [weak self] result in
                self?.properties = result
            }
            .store(in: &bag)

    }
}

extension PropertiesViewModel{
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
