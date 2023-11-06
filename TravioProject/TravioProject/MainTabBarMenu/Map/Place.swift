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
    let coverImageUrl: URL
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
}

struct PlaceResponse: Codable {
    let data: PlaceData
    let status: String
}

struct PlaceData: Codable {
    let count: Int
    let places: [Place]
}


