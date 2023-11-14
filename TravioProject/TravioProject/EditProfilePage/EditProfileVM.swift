//
//  EditProfileVM.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 7.11.2023.
//

import Foundation
import Alamofire
import UIKit

class EditProfileVM {
    

    var imageURLs: (([String]) -> Void)?
    
    
    var userProfileDidChange: ((UserProfile) -> Void)?
    
    var userProfile: UserProfile? {
        didSet {
            guard let userProfile = userProfile else { return }
            userProfileDidChange?(userProfile)
        }
    }
    
    var updateProfileResponse:UserProfileUpdateResponse?
    

    func formatServerDate(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSX"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }

    func getPersonalInfo() {
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .getPersonalInfo, callback: {(result: Result<UserProfile, APIError>) in
            switch result {
            case .success(let userProfile):
                self.userProfile = userProfile
            case .failure(let failure):
                print(failure.message)
                
            }
        })
    }
    
    func updateUserProfile(fullName: String, email: String, pp_url: String) {
        let parameters = [
            "full_name": fullName,
            "email": email,
            "pp_url": pp_url
        ] as [String : Any]
        
        GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .editProfile(params: parameters)) { (result: Result<UserProfileUpdateResponse, APIError>) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print("Profil güncellemesi başarısız: \(error.message)")
            }
        }
    }

    public func uploadImage(images: [UIImage], completion: @escaping ([String]) -> Void) {
        let url = "https://ios-class-2f9672c5c549.herokuapp.com/upload"
        let headers = HTTPHeaders(["Content-Type": "multipart/form-data"])
        
        GenericNetworkingHelper.shared.uploadImages(images: images, url: url, headers: headers) { (result: Result<UploadResponse, APIError>) in
            switch result {
            case .success(let success):
                completion(success.urls)
            case .failure(let failure):
                print(failure.message)
                completion([])
            }
        }
    }
    

}
