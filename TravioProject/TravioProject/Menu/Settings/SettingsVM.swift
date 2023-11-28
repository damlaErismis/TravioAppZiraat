//
//  SettingsVM.swift
//  TravioProject
//
//  Created by Burak Özer on 9.11.2023.
//

import Foundation

class SettingsVM {
    
    var userProfileResponse:UserProfileResponse? {
        didSet{
            getUserProfileData?()
        }
    }
    var errorStatusMessage:ErrorResponse?{
        didSet{
        }
    }
    
    var getUserProfileData: (()->())?
    
    func initFetch(){
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getUserProfile, callback: {(result: Result<UserProfileResponse,APIError>) in
            switch result {
            case .success(let success):
                self.userProfileResponse = success
            case .failure(let failure):
                switch failure {
                case .apiError(let status, _):
                    switch status {
                    case .unauthorized:
                        self.errorStatusMessage = ErrorResponse(status: "Unauthorized", message: "Invalid credentials")
                    case .forbidden:
                        self.errorStatusMessage = ErrorResponse(status: "Forbidden", message: "Access to this resource is forbidden.")
                    case .notFound:
                        self.errorStatusMessage = ErrorResponse(status: "Not Found", message: "Resources not found")
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
