//
//  LoginVM.swift
//  TravioProject
//
//  Created by Burak Özer on 26.10.2023.
//

import Foundation
import Alamofire


class LoginVM{
    
    var loginSuccessResponse:LoginSuccessResponse? {
        didSet{
            self.makeLogin?()
        }
    }
    
    var errorStatusMessage: ErrorResponse? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var isLoading: Bool? {
        didSet {
            self.updateLoadingStatus?(isLoading!)
        }
    }
    var updateLoadingStatus: ((Bool)->())?
    
    var makeLogin: (()->())?
    var showAlertClosure: (()->())?
    
    func postLoginData(email:String, password: String){
        self.isLoading = true
        let params = [
            "email": email,
            "password": password
        ]
        GenericNetworkingHelper.shared.fetchData(urlRequest: .login(params: params as Parameters), callback: {(result: Result<LoginSuccessResponse,APIError>) in
            self.isLoading = false
            switch result {
            case .success(let success):
                self.loginSuccessResponse = success
                KeychainHelper.shared.setToken(response: success)
            case .failure(let failure):
                switch failure {
                case .apiError(let status, _):
                    switch status {
                    case .unauthorized:
                        self.errorStatusMessage = ErrorResponse(status: "Unauthorized", message: "Invalid credentials")
                    case .forbidden:
                        self.errorStatusMessage = ErrorResponse(status: "Forbidden", message: "Access to this resource is forbidden.")
                    case .notFound:
                        self.errorStatusMessage = ErrorResponse(status: "Not Found", message: "User not found with the given email")
                    default:
                        self.errorStatusMessage = ErrorResponse(status: "Unknown Error", message: "Unknown error occurred.")
                    }
                default:
                    self.errorStatusMessage = ErrorResponse(status: "Error", message: failure.localizedDescription)
                }
            }
        })
    }
}
