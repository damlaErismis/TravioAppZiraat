//
//  EditProfileModel.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 7.11.2023.
//

import Foundation

struct UserProfileUpdateRequest: Encodable {
    let full_name: String?
    let email: String?
    let pp_url: String?
}

struct UserProfileUpdateResponse: Codable {
    let message: String?
    let status: String?
}

struct UserProfile: Codable {
    let full_name: String
    let email: String
    let pp_url: String
    let role: String
    let created_at: String
}

