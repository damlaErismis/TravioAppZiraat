//
//  AddNewPlaceVM.swift
//  TravioProject
//
//  Created by Burak Özer on 6.11.2023.
//

import Foundation
import Alamofire
import UIKit

class AddNewPlaceVM {
    
    
    let dispatchGroup = DispatchGroup()
    var imageUrls:[String]?
    var placeId:String?
    
    var uploadResponse:UploadResponse?{
        didSet{
            imageUrls = uploadResponse?.urls
            addNewPlaceClosure?()
        }
    }
    var  placeResponse:SuccessResponse?{
        didSet{
            placeId = placeResponse?.message
            addGalleriesClosure?()
        }
    }
    var  galleryResponse:SuccessResponse?{
        didSet{
            showSuccessAlertClosure?()
        }
    }
    var errorStatusMessage: ErrorResponse?{
        didSet {
            self.showErrorAlertClosure?()
        }
    }
    var errorGalleryErrorResponse: ErrorResponse?{
        didSet {
            self.showErrorGalleryAlertClosure?()
        }
    }
    
    var addNewPlaceClosure : (()->())?
    var addGalleriesClosure : (()->())?
    var showErrorAlertClosure: (()->())?
    var showSuccessAlertClosure: (()->())?
    var showErrorGalleryAlertClosure: (()->())?
    
    public func addNewPlace(place:String, placeTitle:String, placeDescription:String, imageString:String, latitude:Double, longitude:Double){
        let params = [
            "place": place,
            "title": placeTitle,
            "description": placeDescription,
            "cover_image_url":imageString,
            "latitude": latitude,
            "longitude": longitude
        ] as [String : Any]
        GenericNetworkingHelper.shared.fetchData(urlRequest: .postAPlace(params: params), callback: {(result: Result<SuccessResponse,APIError>) in
            self.dispatchGroup.enter()
            switch result {
            case .success(let success):
                self.placeResponse = success
            case .failure(let failure):
                switch failure {
                case .apiError(let status, _):
                    switch status {
                    case .unauthorized:
                        self.errorGalleryErrorResponse = ErrorResponse(status: "Unauthorized", message: "Invalid credenials")
                    case .forbidden:
                        self.errorGalleryErrorResponse = ErrorResponse(status: "Forbidden", message: "Access to this resource is forbidden.")
                    default:
                        self.errorGalleryErrorResponse = ErrorResponse(status: "Unknown Error", message: "Unknown error occurred.")
                    }
                default:
                    self.errorGalleryErrorResponse = ErrorResponse(status: "Error", message: failure.localizedDescription)
                }
            }
            self.dispatchGroup.leave()
        })
    }
    
    public func createGalleryImage(placeId:String, imageURL: String){
        let params = [
            "place_id": placeId,
            "image_url": imageURL
        ]
        GenericNetworkingHelper.shared.fetchData(urlRequest: .postAGalleryImage(params: params), callback: {(result: Result<SuccessResponse, APIError>) in
            self.dispatchGroup.enter()

            switch result {
            case .success(let success):
                self.galleryResponse = success
            case .failure(let failure):
                switch failure {
                case .apiError(let status, _):
                    switch status {
                    case .unauthorized:
                        self.errorStatusMessage = ErrorResponse(status: "Unauthorized", message: "Invalid credenials")
                    case .forbidden:
                        self.errorStatusMessage = ErrorResponse(status: "Forbidden", message: "Access to this resource is forbidden.")
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
    
    public func uploadImages(images: [UIImage]){

        GenericNetworkingHelper.shared.uploadImagess(urlRequest: .uploadImages(images: images),  callback: {(result: Result<UploadResponse,APIError>) in
            self.dispatchGroup.enter()

            switch result {
            case .success(let success):
                self.uploadResponse = success
            case .failure(let failure):
                switch failure {
                case .apiError(let status, _):
                    switch status {
                    case .unauthorized:
                        self.errorStatusMessage = ErrorResponse(status: "Unauthorized", message: "Invalid credenials")
                    case .forbidden:
                        self.errorStatusMessage = ErrorResponse(status: "Forbidden", message: "Access to this resource is forbidden.")
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
