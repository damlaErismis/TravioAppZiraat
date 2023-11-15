//
//  Router.swift
//  TravioProject
//
//  Created by Burak Özer on 25.10.2023.
//

import Foundation
import Alamofire
import UIKit

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
    case checkVisitByPlaceId(placeId:String)
    case postAPlace(params:Parameters)
    case postAGalleryImage(params:Parameters)
    case getUserProfile
    case changePassword(params:Parameters)
    case uploadImages(images:[UIImage])
    
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
        case .deleteAVisit(let placeId) :
            return "/v1/visits/\(placeId)"
        case .checkVisitByPlaceId(let placeId):
            return "/v1/visits/user/\(placeId)"
        case .postAPlace:
            return "/v1/places"
        case .postAGalleryImage:
            return "/v1/galleries"
        case .getUserProfile, .getPersonalInfo:
            return "/v1/me"
        case .changePassword:
            return "v1/change-password"
        case .editProfile:
            return "v1/edit-profile"
        case .uploadImages:
            return "/upload"
        }
    }
    var method:HTTPMethod {
        switch self {
        case .signUp, .login, .postAVisit, .postAPlace, .postAGalleryImage, .uploadImages:
            return .post
        case .getAllPlaces, .getAllGalleryByPlaceID, .getAPlaceById, .getAllPlacesForUser, .getPopularPlaces, .getLastPlaces, .checkVisitByPlaceId, .getUserProfile, .getPersonalInfo, .getPopularPlacesWithLimit, .getLastPlacesWithLimit:
            return .get
        case .deleteAVisit:
            return .delete
        case .editProfile, .changePassword:
            return .put
        }}
    var headers:HTTPHeaders{
        switch self {
        case .signUp, .login, .getAllPlaces, .getAllGalleryByPlaceID, .getAPlaceById, .getPopularPlacesWithLimit, .getLastPlacesWithLimit, .getPopularPlaces, .getLastPlaces:
            return [:]
        case .postAVisit, .deleteAVisit, .checkVisitByPlaceId, .postAPlace, .postAGalleryImage, .getUserProfile, .changePassword,.editProfile, .getPersonalInfo, .getAllPlacesForUser:
            return HTTPHeaders(["Authorization": "Bearer \(token)"])
        case .uploadImages:
            return ["Content-Type": "multipart/form-data"]
        }}
    var param:Parameters? {
        switch self {
        case .signUp(let params), .login(let params), .postAVisit(let params), .postAPlace(let params), .postAGalleryImage(let params), .changePassword(let params), .editProfile(let params):
            return params
        case .getAllPlaces, .getAllGalleryByPlaceID, .getAPlaceById, .deleteAVisit, .getAllPlacesForUser, .getPopularPlaces, .getLastPlaces, .getPersonalInfo,  .checkVisitByPlaceId, .getUserProfile, .uploadImages:
            return nil
        case .getPopularPlacesWithLimit(limit: let limit), .getLastPlacesWithLimit(limit: let limit):
            let limited = min(limit, 20)
            return ["limit": limited]
            
        }}
    var multipartFormData: MultipartFormData {
        let formData = MultipartFormData()
        switch self {
        case .uploadImages(let images):
            
            var imageDatas: [Data] = []
            for image in images {
                if let image = image.jpegData(compressionQuality: 1) {
                    imageDatas.append(image)
                }
            }
            imageDatas.forEach { image in
                formData.append(image, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            }
            return formData
        default:
            break
        }
        return formData
    }
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


