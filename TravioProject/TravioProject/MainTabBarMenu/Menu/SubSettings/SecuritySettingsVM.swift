//
//  SecuritySettingsVM.swift
//  TravioProject
//
//  Created by Burak Özer on 10.11.2023.
//

import Foundation

class SecuritySettingsVM {
    
    private lazy var vm:SecuritySettingsVM = {
        return SecuritySettingsVM()
        
    }()
    
    var successMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var showAlertClosure: (()->())?
    
 
    func changePassword(newPassword:String){

        let params = [
            "new_password": newPassword
        ]
        
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .changePassword(params: params), callback: {(result: Result<SuccessResponse,APIError>) in
            switch result {
            case .success(let success):
                self.successMessage = success.message
            case .failure(let failure):
                print(failure.message)
            }
        })
    }
}
