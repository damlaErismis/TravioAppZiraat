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
    var popularPlaces:[Place] = []
    var newPlaces:[Place] = []
    var myAddedPlaces:[Place] = []
    
    weak var delegate: HomeViewModelDelegate?
    var tableSection: [TableViewSection] = []
    
    let dispatchGroup = DispatchGroup()
    
    var isLoading: Bool? {
        didSet {
            self.updateLoadingStatus?(isLoading!)
        }
    }
    var updateLoadingStatus: ((Bool)->())?
    
    func fetchDataDispatch() {
        self.isLoading = true
        
        dispatchGroup.enter()
        getPopularPlaces()

        dispatchGroup.enter()
        getNewPlaces()
        
        dispatchGroup.enter()
        getMyAddedPlaces()
        
        dispatchGroup.notify(queue: .main) {
            self.tableSection = [.popularPlaces, .newPlaces, .myAddedPlaces]
            self.delegate?.reloadTableView()
            self.isLoading = false
        }
    }
    
    private func getPopularPlaces() {
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getPopularPlacesWithLimit(limit: 5), callback: {(result: Result<PlaceResponse,APIError>) in
            switch result {
            case .success(let success):
                self.tableSection.append(.popularPlaces)
                self.popularPlaces = success.data.places
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            self.dispatchGroup.leave()
        })
    }
    
    private func getNewPlaces() {
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getLastPlacesWithLimit(limit: 5), callback: {(result: Result<PlaceResponse,APIError>) in
            switch result {
            case .success(let success):
                self.tableSection.append(.newPlaces)
                self.newPlaces = success.data.places
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            self.dispatchGroup.leave()
        })
    }
    
    private func getMyAddedPlaces() {
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getAllPlacesForUser, callback: {(result: Result<PlaceResponse,APIError>) in
            switch result {
            case .success(let success):
                self.tableSection.append(.myAddedPlaces)
                self.myAddedPlaces = success.data.places
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            self.dispatchGroup.leave()
        })
    }
}


