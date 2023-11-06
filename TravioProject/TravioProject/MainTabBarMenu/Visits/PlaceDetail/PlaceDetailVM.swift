//
//  PlaceDetailVM.swift
//  TravioProject
//
//  Created by Burak Özer on 3.11.2023.
//

import Foundation

class PlaceDetailVM {

    var selectedID: String
    
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
    
    var successCheckIdResponse: PostDeleteVisitCheckResponse? {
        didSet {
            successCheckId?()
        }
    }
    var errorCheckIdResponse:String?{
        didSet {
            errorCheckId?()
        }
    }
    
    var errorCheckId:(()->())?
    var successCheckId:(()->())?
    var reloadPageControlPages: (()->())?
    var reloadCompositionalLayoutClosure: (()->())?
    var reloadClosure: (()->())?
    var showAlertClosure: (()->())?
    
    init(selectedID: String) {
        self.selectedID = selectedID
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
        
        let params = [
            "place_id": placeId,
            "visited_at": visitedAt
//            "visited_at": "2023-08-10T00:00:00Z"
            ]
        
        print(params)
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .postAVisit(params: params), callback: {(result: Result<PostDeleteVisitCheckResponse,APIError>) in
            switch result {
            case .success(let success):
                self.successMessage = success.message
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
    func deleteAVisit(placeId:String){
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .deleteAVisit(placeId: placeId), callback: {(result: Result<PostDeleteVisitCheckResponse,APIError>) in
            switch result {
            case .success(let success):
                self.successMessage = success.message
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
    
    func checkVisit(placeId:String){
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .checkVisitByPlaceId(placeId: placeId), callback: {(result: Result<PostDeleteVisitCheckResponse,APIError>) in
            switch result {
            case .success(let success):
                self.successCheckIdResponse = success
            case .failure(let failure):
                self.errorCheckIdResponse = failure.message
            }
        })
    }
}
