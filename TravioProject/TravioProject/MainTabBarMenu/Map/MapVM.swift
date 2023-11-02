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
    
    var getAllPlacesForUser:[Place]? {
        
        didSet{
//            self.makeContactsDataManipulation()
        }
    }
    

    var isLoading: Bool = false {
        didSet {
            
//            self.updateLoadingStatus?()
        }
    }
    
//    var reloadTableViewClosure: (()->())?
//    
//    var updateLoadingStatus: (()->())?

    func getToken()->String{
        
        let service = "com.travio"
        let account = "travio"
        guard let storedTokenData = KeychainHelper.shared.read(service: service, account: account),
              let storedToken = String(data: storedTokenData, encoding: .utf8) else{
            return "Token okunamadı veya bulunamadı."
        }
        return storedToken
    }

    
    func initFetch(){
        
        let token = getToken()
        let headers:HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        GenericNetworkingHelper.shared.getDataFromRemoteWithHeader(urlRequest: .getAllPlacesForUser, headers: headers, callback: {(result: Result<[Place],APIError>) in
            switch result {
            case .success(let success):
                self.getAllPlacesForUser = success
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
}
