//
//  Visit.swift
//  TravioProject
//
//  Created by Burak Özer on 2.11.2023.
//

import Foundation

struct VisitedPlace: Codable {
    let id: String
    let creator: String
    let location: String
    let title: String
    let description: String
    let coverImageUrl: String
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
}

struct Visit: Codable {
    let id: String
    let placeId: String
    let visitedAt: String
    let createdAt: String
    let updatedAt: String
    let place: VisitedPlace
}

struct VisitResponse: Codable {
    let data: VisitData
    let status: String
}

struct VisitData: Codable {
    let count: Int
    let visits: [Visit]
}

