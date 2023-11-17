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
    
    func initFetch(){
        GenericNetworkingHelper.shared.getDataFromRemotee(urlRequest: .getAllPlaces, callback: {(result: Result<PlaceResponse,APIErrorMessage>) in
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
