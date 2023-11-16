//
//  Visit.swift
//  TravioProject
//
//  Created by Damla Erişmiş on 15.11.2023.
//

import Foundation

struct DataResponse: Codable {
    var data: DataClass
    var status: String
}

struct DataClass: Codable {
    var count: Int
    var visits: [Visit]
}

struct Visit: Codable {
    var id: String
    var place_id: String
    var visited_at: String
    var created_at: String
    var updated_at: String
    var place: Place
}

