//
//  LoginVM.swift
//  TravioProject
//
//  Created by Burak Özer on 26.10.2023.
//

import Foundation
import Alamofire

class LoginVM{
    
    var loginSuccessResponse:LoginSuccessResponse?
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    var showAlertClosure: (()->())?
    

    func postLoginData(email:String, password: String){
        
        let params = [
            "email": email,
            "password": password
            ]
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .login(params: params as Parameters), callback: {(result: Result<LoginSuccessResponse, Error>) in
            switch result {
            case .success(let success):
                self.processFetched(response: success)
            case .failure(let failure):
                self.alertMessage = failure.localizedDescription
            }
        })
    }
    
   func processFetched( response: LoginSuccessResponse ) {
         self.loginSuccessResponse = response
     }
     
 }
    
    
    
    
    
    
    
