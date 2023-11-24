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
    var errorStatusMessage:ErrorResponse?{
        didSet{
            
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
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getAllPlaces, callback: {(result: Result<PlaceResponse,APIError>) in
            switch result {
            case .success(let success):
                self.getData = success
                self.getPlacesData()
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
