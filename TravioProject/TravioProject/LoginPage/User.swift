//
//  User.swift
//  TravioProject
//
//  Created by Burak Özer on 25.10.2023.
//

import Foundation

struct User:Codable {
    
    var email:String?
    var password:String?
    var userName:String?
    
    enum CodingKeys:String,CodingKey {
        case userName = "full_name"
    }
}
