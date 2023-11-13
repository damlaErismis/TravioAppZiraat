//
//  PlaceDetail.swift
//  TravioProject
//
//  Created by Burak Özer on 3.11.2023.
//

import Foundation

struct ImageData: Codable {
    let data: ImageDataDetails
    let status: String
}

struct ImageDataDetails: Codable {
    let count: Int
    let images: [Image]
}

struct Image: Codable {
    let id: String
    let place_id: String
    let image_url: String
    let created_at: String
    let updated_at: String
}

