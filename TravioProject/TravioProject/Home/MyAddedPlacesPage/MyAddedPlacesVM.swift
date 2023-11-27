//
//  MyAddedPlacesVM.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 14.11.2023.
//

import Foundation

class MyAddedPlacesVM {
    
    var myAddedPlacesResponse:PlaceResponse? {
        didSet {
            myAddedPlacesChange?()
        }
    }

    var myAddedPlaces:[Place] = [] {
        didSet {
            self.reloadCollectionViewForMyAddedPlaces?()
        }
    }

    var errorStatusMessage:ErrorResponse?{
        didSet {
            
        }
    }
    var isLoading: Bool? {
        didSet {
            self.updateLoadingStatus?(isLoading!)
        }
    }
    var updateLoadingStatus: ((Bool)->())?
    
    var myAddedPlacesChange: (() -> Void)?
    var reloadCollectionViewForMyAddedPlaces: (() -> Void)?
    
    func getMyAddedPlacesData(){
        
        guard let myAddedPlaces = myAddedPlacesResponse?.data.places else {return}
        self.myAddedPlaces = myAddedPlaces
    }
    
    func getPopularPlaces(completion: @escaping (Result<PlaceResponse, Error>) -> Void) {
        self.isLoading = true
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getAllPlacesForUser, callback: {(result: Result<PlaceResponse,APIError>) in
            self.isLoading = false
            switch result {
            case .success(let success):
                self.myAddedPlacesResponse = success
                self.getMyAddedPlacesData()
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

