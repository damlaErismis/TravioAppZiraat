//
//  Router.swift
//  TravioProject
//
//  Created by Burak Özer on 25.10.2023.
//

import Foundation
import Alamofire


enum Router{
    
    case signUp(params:Parameters)
    case login(params:Parameters)
    case getAllPlacesForUser
    case getPopularPlaces(limit: Int)
    case getLastPlaces(limit: Int)
    
    var baseURL:String{
        return "https://api.iosclass.live"
    }
    var path:String{
        switch self {
        case .signUp:
            return "/v1/auth/register"
        case .login:
            return "/v1/auth/login"
        case .getAllPlacesForUser:
            return "/v1/places/user"
        case .getPopularPlaces:
            return "/v1/places/popular"
        case .getLastPlaces:
            return "/v1/places/last"
        }
    }
    var method:HTTPMethod {
        switch self {
        case .signUp, .login:
            return .post
        case .getAllPlacesForUser, .getPopularPlaces, .getLastPlaces:
            return .get
        
        }}
    var header:HTTPHeaders{
        switch self {
        case .signUp, .login, .getPopularPlaces, .getLastPlaces:
            return [:]
        
        case .getAllPlacesForUser:
            return HTTPHeaders(["Authorization": "Bearer"])
        }}
    var param:Parameters? {
        switch self {
        case .signUp(let params):
            return params
        case .login(let params):
            return params
        case .getAllPlacesForUser:
            return nil
        case .getPopularPlaces(limit: let limit), .getLastPlaces(limit: let limit):
            let limited = min(limit, 20)
            return ["limit": limited]
        }}
}

extension Router:URLRequestConvertible{
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlComponent = URLRequest(url: url.appendingPathComponent(path))
        urlComponent.httpMethod = method.rawValue
        urlComponent.headers = header
        let encoding:ParameterEncoding = {
            switch method {
            case .post:
                return JSONEncoding.default
            default:
                return URLEncoding.default
            }
        }()
        return try encoding.encode(urlComponent, with: param)
    }
}


