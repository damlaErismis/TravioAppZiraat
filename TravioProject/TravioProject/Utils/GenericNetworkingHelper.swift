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
    typealias Callback<T:Codable> = (Result<T,Error>)->Void
    public func getDataFromRemote<T:Codable>(urlRequest:Router, callback:@escaping Callback<T>) {
        AF.request(urlRequest).validate().responseDecodable(of:T.self) { response in
            switch response.result {
            case .success(let success):
                callback(.success(success))
            case .failure(let failure):
                callback(.failure(failure))
            }
        }
    }
}
