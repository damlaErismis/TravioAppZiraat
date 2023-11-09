//
//  HomeVM.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 2.11.2023.
//

import Foundation
import Alamofire

protocol HomeViewModelDelegate: AnyObject {
    func reloadTableView()
}


final class HomeVM {
    
    enum TableViewSection {
        case popularPlaces
        case newPlaces
        case myAddedPlaces
    }
    var popularPlaces:[PopularPlaces] = []
    var newPlaces: [PopularPlaces] = []
    var myAddedPlaces: [PopularPlaces] = []
    
    weak var delegate: HomeViewModelDelegate?
    var tableSection: [TableViewSection] = []

    func getToken()-> String{
        
        let service = "com.travio"
        let account = "travio"
        guard let storedTokenData = KeychainHelper.shared.read(service: service, account: account),
              let storedToken = String(data: storedTokenData, encoding: .utf8) else{
            return "Token okunamadı veya bulunamadı."
        }
        return storedToken
    }
    
    
//    func getPopularPlacesWithLimit(completion: @escaping (Result<PopularPlacesResponse, Error>) -> Void) {
//        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .getPopularPlacesWithLimit(limit: 20), callback: {(result: Result<PopularPlacesResponse,APIError>) in
//            switch result {
//            case .success(let success):
//                self.popularPlaces = success.data.places
//            case .failure(let failure):
//                print(failure.message)
//            }
//        })
//    }
    
    func getPopularPlaces() {
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .getPopularPlaces, callback: {(result: Result<PopularPlacesResponse,APIError>) in
            switch result {
            case .success(let success):
                self.tableSection.append(.popularPlaces)
                self.popularPlaces = success.data.places
                self.delegate?.reloadTableView()
                self.getNewPlaces()
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
    
    func getNewPlaces() {
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .getLastPlaces, callback: {(result: Result<PopularPlacesResponse,APIError>) in
            switch result {
            case .success(let success):
                self.tableSection.append(.newPlaces)
                self.newPlaces = success.data.places
                self.delegate?.reloadTableView()
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
   
//    func getMyAddedPlaces(){
//        GenericNetworkingHelper.shared.getProfileInfoWithHeader(urlRequest: .getLastPlaces, callback: {(result: Result<PopularPlacesResponse,APIError>) in
//            switch result {
//            case .success(let success):
//                self.tableSection.append(.newPlaces)
//                self.newPlaces = success.data.places
//                self.delegate?.reloadTableView()
//            case .failure(let failure):
//                print(failure.message)
//            }
//        })
//    }

}


