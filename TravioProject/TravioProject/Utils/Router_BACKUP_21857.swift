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
    case getLastPlaces(limit: Int)
    
    case getAllPlaces
    case getAllGalleryByPlaceID(placeId:String)
    case getAPlaceById(placeId:String)
    case postAVisit(params:Parameters)
    case deleteAVisit(placeId:String)
    case checkVisitByPlaceId(placeId:String)
    case postAPlace(params:Parameters)
    case postAGalleryImage(params:Parameters)
    
    var baseURL:String{
        return "https://ios-class-2f9672c5c549.herokuapp.com"
    }
    var token:String {
        let token = KeychainHelper.shared.getToken()
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
        case .getLastPlaces:
            return "/v1/places/last"
        case .getAllPlaces:
            return "/v1/places"
        case .getAllGalleryByPlaceID(let placeId):
            return "/v1/galleries/\(placeId)"
        case .getAPlaceById(let placeId):
            return "/v1/places/\(placeId)"
        case .postAVisit:
            return "/v1/visits"
        case .deleteAVisit(let placeId), .checkVisitByPlaceId(let placeId) :
            return "/v1/visits/\(placeId)"
        case .postAPlace:
            return "/v1/places"
        case .postAGalleryImage:
            return "/v1/galleries"
        }
    }
    var method:HTTPMethod {
        switch self {
        case .signUp, .login, .postAVisit, .postAPlace, .postAGalleryImage:
            return .post
        case .getAllPlaces, .getAllGalleryByPlaceID, .getAPlaceById, .getAllPlacesForUser, .getPopularPlacesWithLimit, .getLastPlaces, .getPopularPlaces:
            return .get
        case .deleteAVisit, .checkVisitByPlaceId:
            return .delete
        
        }}
    var headers:HTTPHeaders{
        switch self {
        case .signUp, .login, .getAllPlaces, .getAllGalleryByPlaceID, .getAPlaceById, .getPopularPlacesWithLimit, .getLastPlaces, .getAllPlacesForUser, .getPopularPlaces:
            return [:]
        case .postAVisit, .deleteAVisit, .checkVisitByPlaceId, .postAPlace, .postAGalleryImage:
            return HTTPHeaders(["Authorization": "Bearer \(token)"])

        }}
    var param:Parameters? {
        switch self {
        case .signUp(let params):
            return params
        case .login(let params):
            return params
<<<<<<< HEAD
        case .getAllPlaces, .getAllGalleryByPlaceID, .getAPlaceById, .deleteAVisit, .getAllPlacesForUser, .getPopularPlaces:
=======
        case .getAllPlaces, .getAllGalleryByPlaceID, .getAPlaceById, .deleteAVisit, .getAllPlacesForUser, .checkVisitByPlaceId:
>>>>>>> sprint3/addNewPlaceVM
            return nil
        case .getPopularPlacesWithLimit(limit: let limit), .getLastPlaces(limit: let limit):
            let limited = min(limit, 20)
            return ["limit": limited]
        case .postAVisit(let params):
            return params
        case .postAPlace(let params):
            return params
        case .postAGalleryImage(let params):
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
            case .post:
                return JSONEncoding.default
            default:
                return URLEncoding.default
            }
        }()
        return try encoding.encode(urlComponent, with: param)
    }
}

