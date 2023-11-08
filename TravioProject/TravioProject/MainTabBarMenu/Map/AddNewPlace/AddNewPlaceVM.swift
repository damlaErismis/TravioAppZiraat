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
            
        }
    }

   
    var addNewPlaceClosure : (()->())?
    var addGalleriesClosure : (()->())?

    
    public func addNewPlace(place:String, placeTitle:String, placeDescription:String, imageString:String, latitude:Double, longitude:Double){
        
//        let imageURL = URL(string: imageString)

        let params = [
            "place": place,
            "title": placeTitle,
            "description": placeDescription,
            "cover_image_url":imageString,
            "latitude": latitude,
            "longitude": longitude
        ] as [String : Any]
        
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .postAPlace(params: params), callback: {(result: Result<SuccessResponse,APIError>) in
            switch result {
            case .success(let success):
                self.placeResponse = success
     
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
    
    public func createGalleryImage(placeId:String, imageURL: String){
        let params = [
            "place_id": placeId,
            "image_url": imageURL
        ]
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .postAGalleryImage(params: params), callback: {(result: Result<SuccessResponse,APIError>) in
            switch result {
            case .success(let success):
                self.galleryResponse = success
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
    
    public func uploadImage(images: [UIImage]){
        
        let url = "https://ios-class-2f9672c5c549.herokuapp.com/upload"
        let headers = HTTPHeaders(["Content-Type": "multipart/form-data"])
        
        GenericNetworkingHelper.shared.uploadImages(images: images, url: url, headers: headers, callback: {(result: Result<UploadResponse,APIError>) in
            switch result {
            case .success(let success):
                self.uploadResponse = success
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
    
    
}
