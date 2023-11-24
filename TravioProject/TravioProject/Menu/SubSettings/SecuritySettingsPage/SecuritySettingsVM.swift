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
            self.showSuccessAlertClosure?()
        }
    }
    
    var errorStatusMessage:ErrorResponse? {
        didSet {
            self.showErrorAlertClosure?()
        }
    }
    var showSuccessAlertClosure: (()->())?
    var showErrorAlertClosure: (()->())?
    func changePassword(newPassword:String){
        let params = [
            "new_password": newPassword
        ]
        
        GenericNetworkingHelper.shared.fetchData(urlRequest: .changePassword(params: params), callback: {(result: Result<SuccessResponse,APIError>) in
            switch result {
            case .success(let success):
                self.successMessage = success.message
            case .failure(let failure):
                switch failure {
                case .apiError(let status, _):
                    switch status {
                    case .unauthorized:
                        self.errorStatusMessage = ErrorResponse(status: "Unauthorized", message: "Signature is invalid")
                    case .forbidden:
                        self.errorStatusMessage = ErrorResponse(status: "Forbidden", message: "Access to this resource is forbidden.")
                    case .badRequest:
                        self.errorStatusMessage = ErrorResponse(status: "Fail", message: "Too many characters for password")
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
