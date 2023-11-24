//
//  NewPlacesVM.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 6.11.2023.
//

import Foundation
import Alamofire

class NewPlacesVM {
    
    var newPlacesResponse:PlaceResponse? {
        didSet {
            newPlacesChange?()
        }
    }
    var newPlaces:[Place] = [] {
        didSet {
            self.reloadCollectionViewForNewPlaces?()
        }
    }
    
    var errorStatusMessage:ErrorResponse? {
        didSet{
            
        }
    }
    var newPlacesChange: (() -> Void)?
    var reloadCollectionViewForNewPlaces: (() -> Void)?

    func getNewPlacesData(){
        
        guard let newPlaces = newPlacesResponse?.data.places else {return}
        self.newPlaces = newPlaces
    }

    func getNewPlaces(completion: @escaping (Result<PlaceResponse, Error>) -> Void) {
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getLastPlaces, callback: {(result: Result<PlaceResponse,APIError>) in
            switch result {
            case .success(let success):
                self.newPlacesResponse = success
                self.getNewPlacesData()
            case .failure(let failure):
                switch failure {
                case .apiError(let status, _):
                    switch status {
                    case .unauthorized:
                        self.errorStatusMessage = ErrorResponse(status: "Unauthorized", message: "Invalid credentials")
                    case .forbidden:
                        self.errorStatusMessage = ErrorResponse(status: "Forbidden", message: "Access to this resource is forbidden.")
                    case .notFound:
                        self.errorStatusMessage = ErrorResponse(status: "Not Found", message: "Resources not found")
                    default:
                        self.errorStatusMessage = ErrorResponse(status: "Unknown Error", message: "Unknown error occurred.")
                    }
                default:
                    self.errorStatusMessage = ErrorResponse(status: "Error", message: failure.localizedDescription)
                }
            }
        })
    }
}
