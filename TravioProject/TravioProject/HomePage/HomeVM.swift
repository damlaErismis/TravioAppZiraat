//
//  HomeVM.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 2.11.2023.
//

import Foundation
import Alamofire

class HomeVM {
    
    var places: [HomePlaces] = [] {
        didSet {
            placesDidChange?()
        }
    }

    var placesDidChange: (() -> Void)?

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
        
        GenericNetworkingHelper.shared.getDataFromRemoteWithHeader(urlRequest: .getAllPlacesForUser, headers: headers, callback: {(result: Result<[HomePlaces],APIError>) in
            switch result {
            case .success(let success):
                self.places = success
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
}


