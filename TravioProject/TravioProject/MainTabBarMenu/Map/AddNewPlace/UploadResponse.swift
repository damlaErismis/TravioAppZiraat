//
//  UploadResponse.swift
//  TravioProject
//
//  Created by Burak Özer on 7.11.2023.
//

import Foundation

struct UploadResponse: Codable {
    var messageType: String
    var message: String
    var urls: [String]
}
