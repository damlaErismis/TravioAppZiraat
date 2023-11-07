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

    var isLoading: Bool = false {
        didSet {
            
//            self.updateLoadingStatus?()
        }
    }
    
    var places:[Place] = [] {
        didSet{
            
        }
    }
    func getPlacesData(){
        guard let places = getData?.data.places else{
            return
        }
        self.places = places
    }
    
    
    var reloadCollectionViewClosure: (()->())?
//    
//    var updateLoadingStatus: (()->())?
    
    
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
