//
//  ApiErrorStatus.swift
//  TravioProject
//
//  Created by Burak Özer on 4.11.2023.
//

import Foundation

// Bu sayfa geliştirilecek

struct ErrorResponse: Error{
    var status: String
    var message: String
}

enum APIErrorStatus: Int {
    case internalServerError = 500
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case unknown = -1
}

enum APIError: Error {
    case networkError
    case invalidResponse
    case apiError(status: APIErrorStatus, message: String)
    
     init(status: APIErrorStatus, message: String) {
         self = .apiError(status: status, message: message)
     }
    
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
