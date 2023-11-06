//
//  GenericNetworkingHelper.swift
//  TravioProject
//
//  Created by Burak Özer on 25.10.2023.
//

import Foundation
import Alamofire

class GenericNetworkingHelper{
    
    static let shared = GenericNetworkingHelper()
    typealias Callback<T: Codable> = (Result<T, APIError>) -> Void
    
    public func getDataFromRemote<T: Codable>(urlRequest: Router, callback: @escaping Callback<T>) {
        AF.request(urlRequest).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let success):
                callback(.success(success))
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    let apiError = APIError(statusCode: statusCode, message: error.localizedDescription)
                    callback(.failure(apiError))
                } else {
                    let unknownError = APIError(statusCode: -1, message: "Unknown error occurred")
                    callback(.failure(unknownError))
                }
            }
        }
    }
    
}

