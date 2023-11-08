//
//  AddPlaceRequest.swift
//  TravioProject
//
//  Created by Burak Özer on 8.11.2023.
//

import Foundation

struct AddPlaceRequest{
    
    var place: String
    var title: String
    var description: String
    var cover_image_url: String
    var latitude: Double
    var longitude: Double
    
    init(place: String, title: String, description: String, cover_image_url: String, latitude: Double, longitude: Double) {
        self.place = place
        self.title = title
        self.description = description
        self.cover_image_url = cover_image_url
        self.latitude = latitude
        self.longitude = longitude
    }
  
}
