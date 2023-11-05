//
//  PlaceDetailVM.swift
//  TravioProject
//
//  Created by Burak Özer on 3.11.2023.
//

import Foundation

class PlaceDetailVM {
    
    var savedVisitedPlacesIDs: Set<String> = []
    
    let selectedID: String
    
    var galleryData:ImageData? {
        didSet{
            self.reloadCompositionalLayoutClosure?()
        }
    }
    var placeData:PlaceIdData? {
        didSet{
        }
    }
    var place:Place?{
        didSet{
            self.reloadClosure?()
            self.reloadPageControlPages?()
        }
    }
    func getPlaceData(){
        guard let place = placeData?.data.place else{
            return
        }
        self.place = place
    }
    var getId:String? {
        
        didSet{
        }
    }
    var isLoading: Bool = false {
        didSet {
            //   self.updateLoadingStatus?()
        }
    }
    var successMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    var reloadPageControlPages: (()->())?
    var reloadCompositionalLayoutClosure: (()->())?
    var reloadClosure: (()->())?
    var showAlertClosure: (()->())?
    
    init(selectedID: String) {
        
        self.selectedID = selectedID
        if let storedVisitedPlaceIDs = UserDefaults.standard.array(forKey: "savedVisitedPlaceIDs") as? [String] {
               savedVisitedPlacesIDs = Set(storedVisitedPlaceIDs)
           }
    }
    func initFetchImages(){
        
        let id = selectedID
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .getAllGalleryByPlaceID(placeId: id), callback: {(result: Result<ImageData,APIError>) in
            switch result {
            case .success(let success):
                self.galleryData = success
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
    func initFetchLayersAndMap(){
        let id = selectedID
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .getAPlaceById(placeId: id), callback: {(result: Result<PlaceIdData,APIError>) in
            switch result {
            case .success(let success):
                self.placeData = success
                self.getPlaceData()
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
    
    func postAVisit(placeId:String, visitedAt:String){
        
        if let storedVisitedPlaceIDs = UserDefaults.standard.array(forKey: "savedVisitedPlaceIDs") as? [String] {
            savedVisitedPlacesIDs = Set(storedVisitedPlaceIDs)
        }
        savedVisitedPlacesIDs.insert(selectedID)
        UserDefaults.standard.set(Array(savedVisitedPlacesIDs), forKey: "savedVisitedPlaceIDs")
        
        let params = [
            "place_id": placeId,
            "visited_at": visitedAt
            ]
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .postAVisit(params: params), callback: {(result: Result<PostDeleteVisitResponse,APIError>) in
            switch result {
            case .success(let success):
                self.successMessage = success.message
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
    func deleteAVisit(placeId:String){
        
        guard let storedVisitedPlaceIDs = UserDefaults.standard.array(forKey: "savedVisitedPlaceIDs") as? [String] else{
            return
        }
        savedVisitedPlacesIDs = Set(storedVisitedPlaceIDs)
        savedVisitedPlacesIDs.remove(placeId)
        UserDefaults.standard.set(Array(savedVisitedPlacesIDs), forKey: "savedVisitedPlaceIDs")
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .deleteAVisit(placeId: placeId), callback: {(result: Result<PostDeleteVisitResponse,APIError>) in
            switch result {
            case .success(let success):
                self.successMessage = success.message
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
}
