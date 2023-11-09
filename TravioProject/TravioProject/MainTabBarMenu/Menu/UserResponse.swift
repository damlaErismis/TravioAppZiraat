//
//  UserResponse.swift
//  TravioProject
//
//  Created by Burak Özer on 9.11.2023.
//

import Foundation

struct User {
    var fullName: String
    var email: String
    var profilePictureURL: URL
    var role: String
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case email
        case profilePictureURL = "pp_url"
        case role
        case createdAt = "created_at"
    }
}
