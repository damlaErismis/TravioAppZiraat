//
//  MyVisitsVM.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 15.11.2023.
//

import Foundation


class MyVisitsVM {
    
    var getData:DataResponse? {
        didSet{
        }
    }

    var visits:[Visit] = [] {
        didSet {
            self.reloadCollectionViewForVisits?()
        }
    }
    var errorStatusMessage:ErrorResponse?{
        didSet{
            
        }
    }
    var reloadCollectionViewForVisits: (() -> Void)?

    func getPlacesData(){
        guard let visits = getData?.data.visits else{
            return
        }
        self.visits = visits
    }
    
    func getMyVisits(){
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getAllVisits, callback: {(result: Result<DataResponse,APIError>) in
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
