//
//  PopularPlacesVM.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 2.11.2023.
//

import Foundation

class PopularPlacesVM {
    
    var popularPlacesResponse:PlaceResponse? {
        didSet {
            popularPlacesChange?()
        }
    }

    var popularPlaces:[Place] = [] {
        didSet {
            self.reloadCollectionViewForPopularPlaces?()
        }
    }
    
    var errorStatusMessage:ErrorResponse?{
        didSet {
            
        }
    }
    var popularPlacesChange: (() -> Void)?
    var reloadCollectionViewForPopularPlaces: (() -> Void)?
    
    func getPopularPlacesData(){
        
        guard let popularPlaces = popularPlacesResponse?.data.places else {return}
        self.popularPlaces = popularPlaces
    }
    
    func getPopularPlaces(completion: @escaping (Result<PlaceResponse, Error>) -> Void) {
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getPopularPlaces, callback: {(result: Result<PlaceResponse,APIError>) in
            switch result {
            case .success(let success):
                self.popularPlacesResponse = success
                self.getPopularPlacesData()
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
