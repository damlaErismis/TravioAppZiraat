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
    
    var isLoading: Bool? {
        didSet {
            self.updateLoadingStatus?(isLoading!)
        }
    }
    var updateLoadingStatus: ((Bool)->())?
    
    var popularPlacesChange: (() -> Void)?
    var reloadCollectionViewForPopularPlaces: (() -> Void)?
    
    func getPopularPlacesData(){
        
        guard let popularPlaces = popularPlacesResponse?.data.places else {return}
        self.popularPlaces = popularPlaces
    }
    
    func getPopularPlaces(completion: @escaping (Result<PlaceResponse, Error>) -> Void) {
        self.isLoading = true
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getPopularPlaces, callback: {(result: Result<PlaceResponse,APIError>) in
            self.isLoading = false
            switch result {
            case .success(let success):
                self.popularPlacesResponse = success
                self.getPopularPlacesData()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        })
    }
}
