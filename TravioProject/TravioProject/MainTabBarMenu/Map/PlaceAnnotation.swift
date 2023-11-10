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
    var visitDescription:String?
    var titlePlace:String?
    var image:String?
    var addedBy:String?
    var addedDate:String?
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }

}
