//
//  ApiErrorStatus.swift
//  TravioProject
//
//  Created by Burak Özer on 4.11.2023.
//

import Foundation

// Bu sayfa geliştirilecek

enum APIErrorStatus: Int {
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case unknown = -1
}

enum APIErrorMessage: Error {
    case networkError
    case invalidResponse
    case apiError(status: APIErrorStatus, message: String)

    var localizedDescription: String {
        switch self {
        case .networkError:
            return "Network error occurred."
        case .invalidResponse:
            return "Invalid response from the server."
        case .apiError(_, let message):
            return message
        }
    }
}

//
//func initFetchImages() {
//    let id = selectedID
//    GenericNetworkingHelper.shared.getDataFromRemote(urlRequest: .getAllGalleryByPlaceID(placeId: id), callback: {(result: Result<ImageData,APIError>) in
//        switch result {
//        case .success(let success):
//            self.galleryData = success
//        case .failure(let failure):
//            var errorMessage: String
//            switch failure {
//            case .apiError(let status, _):
//                // API hata durumlarına göre özel mesajları oluştur
//                switch status {
//                case .unauthorized:
//                    errorMessage = "Unauthorized access. Please log in."
//                case .forbidden:
//                    errorMessage = "Access to this resource is forbidden."
//                case .notFound:
//                    errorMessage = "Resource not found."
//                default:
//                    errorMessage = "Unknown error occurred."
//                }
//            default:
//                errorMessage = failure.localizedDescription
//            }
//            
//            // Hata mesajını UIAlertController ile göster
//            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertController.addAction(okAction)
//            // ViewController içinde olduğunuzu varsayarak alertController'ı göster
//            self.present(alertController, animated: true, completion: nil)
//        }
//    })
//}
