//
//  SignUpVM.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 26.10.2023.
//

import Foundation
import Alamofire


class SignUpViewModel {
    
    var signupResponse:SuccessResponse?
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var showAlertClosure: (()->())?
    
    func postSignUpData(userName:String, email: String, password: String){
        
        let params = [
            "full_name": userName,
            "email": email,
            "password":password
        ]
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .signUp(params: params as Parameters), callback: { (result: Result<SuccessResponse,APIError>) in
            
            switch result {
            case .success(let success):
                self.processFetched(response: success)
                self.signupResponse = success
                self.alertMessage = self.signupResponse?.message
                
            case .failure(let failure):
                self.alertMessage = failure.localizedDescription
            }
        })
    }
    
    private func processFetched(response: SuccessResponse) {
        if response.status == "success" {
            self.alertMessage = response.message
        } else {
            self.alertMessage = "Registration Failed: " + (response.message )
        }
    }
    
}
