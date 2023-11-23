//
//  
//  MapVMVC.swift
//  TravioProject
//
//  Created by Burak Özer on 31.10.2023.
//
//
import Foundation
import Alamofire

class MapVM {
    
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
    
    var isLoading: Bool? {
        didSet {
            self.updateLoadingStatus?(isLoading!)
        }
    }
    var updateLoadingStatus: ((Bool)->())?
    
    func initFetch(){
        self.isLoading = true
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getAllPlaces, callback: {(result: Result<PlaceResponse,APIError>) in
            self.isLoading = false
            switch result {
            case .success(let success):
                self.getData = success
                self.getPlacesData()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        })
    }
}
