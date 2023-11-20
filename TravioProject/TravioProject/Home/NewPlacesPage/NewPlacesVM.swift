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
    var newPlacesChange: (() -> Void)?
    var reloadCollectionViewForNewPlaces: (() -> Void)?

    func getNewPlacesData(){
        
        guard let newPlaces = newPlacesResponse?.data.places else {return}
        self.newPlaces = newPlaces
    }
    
//    func getNewPlacesWithLimit(completion: @escaping (Result<NewPlacesResponse, Error>) -> Void) {
//        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .getLastPlacesWithLimit(limit: 20), callback: {(result: Result<NewPlacesResponse,APIError>) in
//            switch result {
//            case .success(let success):
//                self.newPlacesResponse = success
//                self.getNewPlacesData()
//            case .failure(let failure):
//                print(failure.message)
//            }
//        })
//    }
    func getNewPlaces(completion: @escaping (Result<PlaceResponse, Error>) -> Void) {
        GenericNetworkingHelper.shared.getDataFromRemotee(urlRequest: .getLastPlaces, callback: {(result: Result<PlaceResponse,APIErrorMessage>) in
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
