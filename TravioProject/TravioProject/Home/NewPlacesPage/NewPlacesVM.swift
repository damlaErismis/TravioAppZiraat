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
    var isLoading: Bool? {
        didSet {
            self.updateLoadingStatus?(isLoading!)
        }
    }
    var updateLoadingStatus: ((Bool)->())?
    
    var newPlacesChange: (() -> Void)?
    var reloadCollectionViewForNewPlaces: (() -> Void)?

    func getNewPlacesData(){
        
        guard let newPlaces = newPlacesResponse?.data.places else {return}
        self.newPlaces = newPlaces
    }

    func getNewPlaces(completion: @escaping (Result<PlaceResponse, Error>) -> Void) {
        self.isLoading = true
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getLastPlaces, callback: {(result: Result<PlaceResponse,APIError>) in
            self.isLoading = false
            switch result {
            case .success(let success):
                self.newPlacesResponse = success
                self.getNewPlacesData()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        })
    }
}
