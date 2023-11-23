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
    var isLoading: Bool? {
        didSet {
            self.updateLoadingStatus?(isLoading!)
        }
    }
    var updateLoadingStatus: ((Bool)->())?
    
    var reloadCollectionViewForVisits: (() -> Void)?

    func getPlacesData(){
        guard let visits = getData?.data.visits else{
            return
        }
        self.visits = visits
    }
    
    func getMyVisits(){
        self.isLoading = true
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getAllVisits, callback: {(result: Result<DataResponse,APIError>) in
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
