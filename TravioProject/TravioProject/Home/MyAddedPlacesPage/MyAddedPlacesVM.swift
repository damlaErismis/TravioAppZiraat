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
    
    var myAddedPlacesChange: (() -> Void)?
    var reloadCollectionViewForMyAddedPlaces: (() -> Void)?
    
    func getMyAddedPlacesData(){
        
        guard let myAddedPlaces = myAddedPlacesResponse?.data.places else {return}
        self.myAddedPlaces = myAddedPlaces
    }
    
    func getPopularPlaces(completion: @escaping (Result<PlaceResponse, Error>) -> Void) {
        GenericNetworkingHelper.shared.getDataFromRemotee(urlRequest: .getAllPlacesForUser, callback: {(result: Result<PlaceResponse,APIErrorMessage>) in
            switch result {
            case .success(let success):
                self.myAddedPlacesResponse = success
                self.getMyAddedPlacesData()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        })
    }
}

