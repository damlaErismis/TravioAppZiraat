//
//  GenericNetworkingHelper.swift
//  TravioProject
//
//  Created by Burak Özer on 25.10.2023.
//

import Foundation
import Alamofire
import UIKit

class GenericNetworkingHelper{
    
    static let shared = GenericNetworkingHelper()
    typealias Callbackk<T: Codable> = (Result<T, APIError>) -> Void
    
    
    typealias Callback<T: Codable> = (Result<T, APIErrorMessage>) -> Void
    
    
    public func getDataFromRemotee<T: Codable>(urlRequest: Router, callback: @escaping Callback<T>) {
        
        DispatchQueue.global(qos: .background).async {
            AF.request(urlRequest).validate().responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let success):
                    callback(.success(success))
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        let apiError = APIErrorMessage(status: APIErrorStatus(rawValue: statusCode)!, message: error.localizedDescription)
                        callback(.failure(apiError))
                    } else {
                        let unknownError = APIErrorMessage(status: APIErrorStatus(rawValue: -1)!, message: "Unknown error occurred")
                        callback(.failure(unknownError))
                    }
                }
            }
        }
    }
    
    public func uploadImagess<T: Codable>(urlRequest: Router, callback: @escaping Callback<T>) {
        DispatchQueue.global(qos: .background).async {
            AF.upload(multipartFormData: urlRequest.multipartFormData, with: urlRequest).validate().responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let success):
                    callback(.success(success))
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        let apiError = APIErrorMessage(status: APIErrorStatus(rawValue: statusCode)!, message: error.localizedDescription)
                        callback(.failure(apiError))
                    } else {
                        let unknownError = APIErrorMessage(status: APIErrorStatus(rawValue: -1)!, message: error.localizedDescription)
                        callback(.failure(unknownError))
                    }
                }
            }
        }
    }
    
}


