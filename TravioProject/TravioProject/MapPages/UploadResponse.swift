//
//  UploadResponse.swift
//  TravioProject
//
//  Created by Burak Özer on 7.11.2023.
//

import Foundation

struct UploadResponse: Codable {
    let messageType: String
    let message: String
    let urls: [String]
}
