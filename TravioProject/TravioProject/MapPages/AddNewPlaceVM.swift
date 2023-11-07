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
    
    var  placeResponse:PlaceResponse?{
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
    

    
    func uploadImage(image: UIImage, completionHandler: @escaping (Result<UploadImageResponse, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completionHandler(.failure(NSError(domain: "Invalid Image Data", code: 500, userInfo: nil) as! APIError))
            return
        }

        let url = "YOUR_UPLOAD_ENDPOINT_URL"
        let headers: HTTPHeaders = ["Authorization": "Bearer YOUR_ACCESS_TOKEN"] // Eğer bir authorization gerekiyorsa

        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                // Diğer multipart form data alanlarını da ekleyebilirsiniz
            },
            to: url,
            method: .post,
            headers: headers
        ).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let data = value as? UploadImageResponse, let imageUrl = data.message {
                    // Sunucudan dönen verilere göre işlem yapabilirsiniz
                    print("Image uploaded successfully. Image URL: \(imageUrl)")
                    completionHandler(.success(data))
                } else {
                    completionHandler(.failure(NSError(domain: "Invalid Response", code: 500, userInfo: nil)))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
