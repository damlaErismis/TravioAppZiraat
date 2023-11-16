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
    
    var reloadCollectionViewForVisits: (() -> Void)?

    func getPlacesData(){
        guard let visits = getData?.data.visits else{
            return
        }
        self.visits = visits
    }
    
    func getMyVisits(){
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .getAllVisits, callback: {(result: Result<DataResponse,APIError>) in
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
