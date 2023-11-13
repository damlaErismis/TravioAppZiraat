//
//  UserResponse.swift
//  TravioProject
//
//  Created by Burak Özer on 9.11.2023.
//

import Foundation

struct UserProfileResponse:Codable {
    var full_name: String
    var email: String
    var pp_url: String
    var role: String
    var created_at: String
}
