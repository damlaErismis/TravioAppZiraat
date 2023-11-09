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
    case getPopularPlaces
    case getPopularPlacesWithLimit(limit: Int)
    case getLastPlaces
    case getLastPlacesWithLimit(limit: Int)
    case editProfile(params:Parameters)
    case getAllPlaces
    case getPersonalInfo
    case getAllGalleryByPlaceID(placeId:String)
    case getAPlaceById(placeId:String)
    case postAVisit(params:Parameters)
    case deleteAVisit(placeId:String)
    
    var baseURL:String{
        return "https://ios-class-2f9672c5c549.herokuapp.com"
    }
    var token:String {
        guard let token = KeychainHelper.shared.getToken() else { return "" }
        return token
    }
    var path:String{
        switch self {
        case .signUp:
            return "/v1/auth/register"
        case .login:
            return "/v1/auth/login"
        case .getAllPlacesForUser:
            return "/v1/places/user"
        case .getPopularPlacesWithLimit, .getPopularPlaces:
            return "/v1/places/popular"
        case .getLastPlacesWithLimit, .getLastPlaces:
            return "/v1/places/last"
        case .getAllPlaces:
            return "/v1/places"
        case .getAllGalleryByPlaceID(let placeId):
            return "/v1/galleries/\(placeId)"
        case .getAPlaceById(let placeId):
            return "/v1/places/\(placeId)"
        case .postAVisit:
            return "/v1/visits"
        case .deleteAVisit(let placeId):
            return "/v1/visits/\(placeId)"
        case .editProfile:
            return "v1/edit-profile"
        case .getPersonalInfo:
            return "v1/me"
        }
    }
    var method:HTTPMethod {
        switch self {
        case .signUp, .login, .postAVisit:
            return .post
        case .getAllPlaces, .getAllGalleryByPlaceID, .getAPlaceById, .getAllPlacesForUser, .getPopularPlacesWithLimit, .getLastPlacesWithLimit, .getPopularPlaces, .getLastPlaces, .getPersonalInfo:
            return .get
        case .deleteAVisit:
            return .delete
        case .editProfile:
            return .put
        }}
    var headers:HTTPHeaders{
        switch self {
        case .signUp, .login, .getAllPlaces, .getAllGalleryByPlaceID, .getAPlaceById, .getPopularPlacesWithLimit, .getLastPlacesWithLimit, .getPopularPlaces, .getLastPlaces:
            return [:]
        case .postAVisit, .deleteAVisit, .editProfile, .getPersonalInfo, .getAllPlacesForUser:
            return HTTPHeaders(["Authorization": "Bearer \(token)"])

        }}
    var param:Parameters? {
        switch self {
        case .signUp(let params):
            return params
        case .login(let params):
            return params
        case .getAllPlaces, .getAllGalleryByPlaceID, .getAPlaceById, .deleteAVisit, .getAllPlacesForUser, .getPopularPlaces, .getLastPlaces, .getPersonalInfo:
            return nil
        case .getPopularPlacesWithLimit(limit: let limit), .getLastPlacesWithLimit(limit: let limit):
            let limited = min(limit, 20)
            return ["limit": limited]
        case .postAVisit(let params):
            return params
        case .editProfile(let params):
            return params
        }}
}

extension Router:URLRequestConvertible{
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlComponent = URLRequest(url: url.appendingPathComponent(path))
        urlComponent.httpMethod = method.rawValue
        urlComponent.headers = headers
        let encoding:ParameterEncoding = {
            switch method {
            case .post, .put:
                return JSONEncoding.default
            default:
                return URLEncoding.default
            }
        }()
        return try encoding.encode(urlComponent, with: param)
    }
}


