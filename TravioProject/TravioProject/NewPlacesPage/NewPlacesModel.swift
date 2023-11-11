//
//  NewPlacesModel.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 6.11.2023.
//

import Foundation

struct NewPlaces: Codable {
    let id: String
    let creator: String
    let place: String
    let title: String
    let description: String
    let cover_image_url: String
    let latitude: Double
    let longitude: Double
    let created_at: String
    let updated_at: String
}

struct NewPlacesResponse: Codable {
    let data: NewPlacesData
    let status: String
}

struct NewPlacesData: Codable {
    let count: Int
    let places: [NewPlaces]
}
