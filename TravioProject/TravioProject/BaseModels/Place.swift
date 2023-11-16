//
//  Place.swift
//  TravioProject
//
//  Created by Burak Özer on 31.10.2023.
//

import Foundation

struct Place: Codable {
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

struct PlaceResponse: Codable {
    let data: PlaceData
    let status: String
}

struct PlaceData: Codable {
    let count: Int
    let places: [Place]
}

struct PlaceIdData: Codable {
    let data: PlaceIdResponse
    let status: String
}

struct PlaceIdResponse: Codable {
    let place: Place
}


