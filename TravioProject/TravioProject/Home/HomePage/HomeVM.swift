//
//  HomeVM.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 2.11.2023.

import Foundation
import Alamofire

final class HomeVM {
    
    enum TableViewSection {
        case popularPlaces
        case newPlaces
        case myAddedPlaces
    }
    var popularPlaces:[Place] = []
    var newPlaces:[Place] = []
    var myAddedPlaces:[Place] = []
    
    var onReloadData: (() -> Void)?
    var tableSection: [TableViewSection] = []
    
    let dispatchGroup = DispatchGroup()
    
    var isLoading: Bool? {
        didSet {
            self.updateLoadingStatus?(isLoading!)
        }
    }
    var errorStatusMessage: ErrorResponse?{
        didSet{
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
            self.onReloadData?()
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
            self.dispatchGroup.leave()
        })
    }
}


