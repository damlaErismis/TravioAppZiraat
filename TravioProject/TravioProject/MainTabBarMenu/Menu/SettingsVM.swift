//
//  SettingsVM.swift
//  TravioProject
//
//  Created by Burak Özer on 9.11.2023.
//

import Foundation

class SettingsVM {
    
    
    var getData:PlaceResponse? {
        didSet{
            
        }
    }


    
    var places:[Place] = [] {
        didSet{
            addPins?()
        }
    }
    func getPlacesData(){
        guard let places = getData?.data.places else{
            return
        }
        self.places = places
    }
    
    
    var addPins: (()->())?

    
    
    func initFetch(){

        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .getAllPlaces, callback: {(result: Result<PlaceResponse,APIError>) in
            switch result {
            case .success(let success):
                self.getData = success
                self.getPlacesData()
            case .failure(let failure):
                print(failure.message)
            }
        })
    }

    
}
