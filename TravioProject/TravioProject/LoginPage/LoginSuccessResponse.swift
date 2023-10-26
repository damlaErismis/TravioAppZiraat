//
//  LoginSuccessResponse.swift
//  TravioProject
//
//  Created by Burak Özer on 26.10.2023.
//

import Foundation

struct LoginSuccessResponse:Codable{

   var accessToken: String?
   var refreshToken: String?
}

