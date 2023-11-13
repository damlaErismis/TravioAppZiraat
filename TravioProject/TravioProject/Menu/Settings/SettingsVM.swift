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
    var getUserProfileData: (()->())?

    func initFetch(){

        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .getUserProfile, callback: {(result: Result<UserProfileResponse,APIError>) in
            switch result {
            case .success(let success):
                self.userProfileResponse = success
            case .failure(let failure):
                print(failure.message)
            }
        })
    }

    
}
