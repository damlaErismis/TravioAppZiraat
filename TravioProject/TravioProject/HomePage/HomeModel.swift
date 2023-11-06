//
//  HomeModel.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 2.11.2023.
//

import Foundation

struct HomePlaces: Codable {
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

struct PlacesResponse: Codable {
    let data: PlacesData
    let status: String
}

struct PlacesData: Codable {
    let count: Int
    let places: [HomePlaces]
}

struct PopularPlaces: Codable {
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

struct PopularPlacesResponse: Codable {
    let data: PopularPlacesData
    let status: String
}

struct PopularPlacesData: Codable {
    let count: Int
    let places: [PopularPlaces]
}
