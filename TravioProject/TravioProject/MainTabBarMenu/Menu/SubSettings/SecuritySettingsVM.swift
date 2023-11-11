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
