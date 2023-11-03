//
//  PlaceAnnotation.swift
//  TravioProject
//
//  Created by Burak Özer on 31.10.2023.
//

import Foundation
import MapKit

class PlaceAnnotation: MKPointAnnotation {
    
    var mapItem:MKMapItem
    let id = UUID()
    var isSelected:Bool = false
    var isSaved:Bool = false
    var visitDescription:String?
    var titlePlace:String?
    var image:String?
    var addedBy:String?
    var addedDate:String?
    

    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    init(mapItem: MKMapItem, isSelected: Bool) {
        self.mapItem = mapItem
        self.isSelected = isSelected
    }
    
    init(mapItem: MKMapItem, isSaved: Bool, visitDescription: String?, titlePlace: String?) {
        self.mapItem = mapItem
        self.isSaved = isSaved
        self.visitDescription = visitDescription
        self.titlePlace = titlePlace
    }
    
    var name:String{
        mapItem.name ?? ""
    }
    
    var location: CLLocation {
        mapItem.placemark.location ?? CLLocation.default
    }
    
    var place:String{
        "\(mapItem.placemark.locality ?? "") \(mapItem.placemark.country ?? "")"
    }

}
