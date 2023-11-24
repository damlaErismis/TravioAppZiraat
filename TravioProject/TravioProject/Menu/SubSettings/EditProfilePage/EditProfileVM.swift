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
    
    var imageUrls:[String]?
    var userProfileDidChange: ((UserProfile) -> Void)?
    
    var uploadResponse:UploadResponse?{
        didSet{
            imageUrls = uploadResponse?.urls
        }
    }
    
    var userProfile: UserProfile? {
        didSet {
            guard let userProfile = userProfile else { return }
            userProfileDidChange?(userProfile)
        }
    }
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    var errorStatusMessage: ErrorResponse? {
        didSet {
            self.showErrorAlertClosure?()
        }
    }
    var errorGalleryErrorResponse: ErrorResponse? {
        didSet {
            self.showErrorGalleryAlertClosure?()
        }
    }
    var showErrorAlertClosure: (()->())?
    var showErrorGalleryAlertClosure: (()->())?
    var showAlertClosure: (()->())?
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
        GenericNetworkingHelper.shared.fetchData(urlRequest: .getPersonalInfo, callback: {(result: Result<UserProfile, APIError>) in
            switch result {
            case .success(let userProfile):
                self.userProfile = userProfile
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
    
    func updateUserProfile(fullName: String, email: String, pp_url: String) {
        let parameters = [
            "full_name": fullName,
            "email": email,
            "pp_url": pp_url
        ] as [String : Any]
        
        GenericNetworkingHelper.shared.fetchData(urlRequest: .editProfile(params: parameters)) { (result: Result<UserProfileUpdateResponse, APIError>) in
            switch result {
            case .success(let success):
                self.processFetched(response: success)
                self.alertMessage = self.updateProfileResponse?.message
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
        }
    }

    public func uploadImages(images: [UIImage]){
        GenericNetworkingHelper.shared.uploadImagess(urlRequest: .uploadImages(images: images),  callback: {(result: Result<UploadResponse,APIError>) in
            switch result {
            case .success(let success):
                self.uploadResponse = success
            case .failure(let failure):
                switch failure {
                case .apiError(let status, _):
                    switch status {
                    case .unauthorized:
                        self.errorStatusMessage = ErrorResponse(status: "Unauthorized", message: "Invalid credenials")
                    case .forbidden:
                        self.errorStatusMessage = ErrorResponse(status: "Forbidden", message: "Access to this resource is forbidden.")
                    default:
                        self.errorStatusMessage = ErrorResponse(status: "Unknown Error", message: "Unknown error occurred.")
                    }
                default:
                    self.errorStatusMessage = ErrorResponse(status: "Error", message: failure.localizedDescription)
                }

            }
        })
    }
    
    private func processFetched(response: UserProfileUpdateResponse) {
        if response.status == "success" {
            self.alertMessage = response.message
        } else {
            self.alertMessage = "" + (response.message ?? "" )
        }
    }
}
