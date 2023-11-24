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
    
    var isLoading: Bool? {
        didSet {
            self.updateLoadingStatus?(isLoading!)
        }
    }
    var errorStatusMessage:ErrorResponse?{
        didSet{
            
        }
    }
    
    var updateLoadingStatus: ((Bool)->())?
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
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getAllGalleryByPlaceID(placeId: id), callback: {(result: Result<ImageData,APIError>) in
            self.dispatchGroup.enter()
            switch result {
            case .success(let success):
                self.galleryData = success
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
    func initFetchLayersAndMap(){
        self.isLoading = true
        let id = selectedID
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getAPlaceById(placeId: id), callback: {(result: Result<PlaceIdData,APIError>) in
            self.isLoading = false
            self.dispatchGroup.enter()
            switch result {
            case .success(let success):
                self.placeData = success
                self.getPlaceData()
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
        GenericNetworkingHelper.shared.fetchData(urlRequest: .postAVisit(params: params), callback: {(result: Result<SuccessResponse,APIError>) in
            self.dispatchGroup.enter()
            switch result {
            case .success(let success):
                self.successMessage = success.message
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
    func deleteAVisit(placeId:String){
        GenericNetworkingHelper.shared.fetchData(urlRequest: .deleteAVisit(placeId: placeId), callback: {(result: Result<SuccessResponse,APIError>) in
            self.dispatchGroup.enter()
            switch result {
            case .success(let success):
                self.successMessage = success.message
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
    func checkVisit(placeId:String){
        GenericNetworkingHelper.shared.fetchData(urlRequest: .checkVisitByPlaceId(placeId: placeId), callback: {(result: Result<SuccessResponse,APIError>) in
            self.dispatchGroup.enter()
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
