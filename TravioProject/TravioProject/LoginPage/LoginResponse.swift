//
//  UserResponse.swift
//  TravioProject
//
//  Created by Burak Özer on 25.10.2023.
//

import Foundation

struct LoginResponse:Codable{

   var accessToken: String?
   var refreshToken: String?
}
