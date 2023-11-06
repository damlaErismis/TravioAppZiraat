//
//  NewPlacesVM.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 6.11.2023.
//

import Foundation
import Alamofire

class NewPlacesVM {
    
    var newPlacesResponse:NewPlacesResponse? {
        didSet {
            newPlacesChange?()
        }
    }
    var newPlaces:[NewPlaces] = [] {
        didSet {
            self.reloadCollectionViewForNewPlaces?()
        }
    }
    var newPlacesChange: (() -> Void)?
    var reloadCollectionViewForNewPlaces: (() -> Void)?

    func getNewPlacesData(){
        
        guard let newPlaces = newPlacesResponse?.data.places else {return}
        self.newPlaces = newPlaces
    }
    
    func getNewPlacesWithLimit(completion: @escaping (Result<NewPlacesResponse, Error>) -> Void) {
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .getLastPlacesWithLimit(limit: 20), callback: {(result: Result<NewPlacesResponse,APIError>) in
            switch result {
            case .success(let success):
                self.newPlacesResponse = success
                self.getNewPlacesData()
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
    func getNewPlaces(completion: @escaping (Result<NewPlacesResponse, Error>) -> Void) {
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .getLastPlaces, callback: {(result: Result<NewPlacesResponse,APIError>) in
            switch result {
            case .success(let success):
                self.newPlacesResponse = success
                self.getNewPlacesData()
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
}
