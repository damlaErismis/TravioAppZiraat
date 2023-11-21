//
//  PlaceDetailVM.swift
//  TravioProject
//
//  Created by Burak Özer on 3.11.2023.
//

import Foundation

class PlaceDetailVM {
    
    let dispatchGroup = DispatchGroup()
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
    var successMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var successCheckIdResponse: String? {
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
<<<<<<< HEAD
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getAllGalleryByPlaceID(placeId: id), callback: {(result: Result<ImageData,APIError>) in
=======
        dispatchGroup.enter()
        GenericNetworkingHelper.shared.getDataFromRemotee(urlRequest: .getAllGalleryByPlaceID(placeId: id), callback: {(result: Result<ImageData,APIErrorMessage>) in
>>>>>>> sprint5/projectRefactor
            switch result {
            case .success(let success):
                self.galleryData = success
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            self.dispatchGroup.leave()
        })
    }
    func initFetchLayersAndMap(){
        let id = selectedID
<<<<<<< HEAD
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getAPlaceById(placeId: id), callback: {(result: Result<PlaceIdData,APIError>) in
=======
        dispatchGroup.enter()
        GenericNetworkingHelper.shared.getDataFromRemotee(urlRequest: .getAPlaceById(placeId: id), callback: {(result: Result<PlaceIdData,APIErrorMessage>) in
>>>>>>> sprint5/projectRefactor
            switch result {
            case .success(let success):
                self.placeData = success
                self.getPlaceData()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            self.dispatchGroup.leave()
        })
    }
    
    func formatServerDate(dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSX"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return dateFormatter.string(from: date)
        }else{
            return ""
        }
    }
    func dateFormatter()->String{
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.string(from: currentDate)
        
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }
    func postAVisit(placeId:String){
        
        let visitedAt = dateFormatter()
        let params = [
            "place_id": placeId,
            "visited_at": visitedAt
        ]
<<<<<<< HEAD
        GenericNetworkingHelper.shared.fetchData(urlRequest: .postAVisit(params: params), callback: {(result: Result<SuccessResponse,APIError>) in
=======
        dispatchGroup.enter()
        GenericNetworkingHelper.shared.getDataFromRemotee(urlRequest: .postAVisit(params: params), callback: {(result: Result<SuccessResponse,APIErrorMessage>) in
>>>>>>> sprint5/projectRefactor
            switch result {
            case .success(let success):
                self.successMessage = success.message
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            self.dispatchGroup.leave()
        })
    }
    func deleteAVisit(placeId:String){
<<<<<<< HEAD
        GenericNetworkingHelper.shared.fetchData(urlRequest: .deleteAVisit(placeId: placeId), callback: {(result: Result<SuccessResponse,APIError>) in
=======
        dispatchGroup.leave()
        GenericNetworkingHelper.shared.getDataFromRemotee(urlRequest: .deleteAVisit(placeId: placeId), callback: {(result: Result<SuccessResponse,APIErrorMessage>) in
>>>>>>> sprint5/projectRefactor
            switch result {
            case .success(let success):
                self.successMessage = success.message
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            self.dispatchGroup.leave()
        })
    }
    func checkVisit(placeId:String){
<<<<<<< HEAD
        GenericNetworkingHelper.shared.fetchData(urlRequest: .checkVisitByPlaceId(placeId: placeId), callback: {(result: Result<SuccessResponse,APIError>) in
=======
        dispatchGroup.enter()
        GenericNetworkingHelper.shared.getDataFromRemotee(urlRequest: .checkVisitByPlaceId(placeId: placeId), callback: {(result: Result<SuccessResponse,APIErrorMessage>) in
>>>>>>> sprint5/projectRefactor
            switch result {
            case .success(let success):
                self.successCheckIdResponse = success.message
            case .failure(let failure):
                self.errorCheckIdResponse = failure.localizedDescription
            }
            self.dispatchGroup.leave()
        })
    }
}
