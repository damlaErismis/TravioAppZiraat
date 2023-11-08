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

    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    var makeLogin: (()->())?
    var showAlertClosure: (()->())?

    func postLoginData(email:String, password: String){
        let params = [
            "email": email,
            "password": password
            ]
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .login(params: params as Parameters), callback: {(result: Result<LoginSuccessResponse,APIError>) in
            switch result {
            case .success(let success):
                self.loginSuccessResponse = success
                KeychainHelper.shared.setToken(response: success)
            case .failure(let failure):
                self.alertMessage = failure.message
            }
        })
    }
    
     
 }
    
    
    
    
    
    
    
