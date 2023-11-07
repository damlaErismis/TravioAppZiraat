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
    var uploadResponse:UploadResponse?{
        didSet{
            
        }
    }
    
    var  placeResponse:PlaceResponse?{
        didSet{
            
        }
    }
    
    var  galleryResponse:GalleryResponse?{
        didSet{
            
        }
    }

    public func addNewPlace(place:String, placeTitle:String, placeDescription:String, imageURL:String, latitude:Double, longitude:Double){
        
        let params = [
            "place": place,
            "title": placeTitle,
            "description": placeDescription,
            "cover_image_url":imageURL,
            "latitude": latitude,
            "longitude": longitude
        ] as [String : Any]
        
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .postAPlace(params: params), callback: {(result: Result<PlaceResponse,APIError>) in
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
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .postAGalleryImage(params: params), callback: {(result: Result<GalleryResponse,APIError>) in
            switch result {
            case .success(let success):
                self.galleryResponse = success
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
    
    public func uploadImage(images: [UIImage]){
        
        let token = KeychainHelper.shared.getToken()
        let url = "https://ios-class-2f9672c5c549.herokuapp.com/upload"
        let headers = HTTPHeaders(["Authorization": "Bearer \(token)"])
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
