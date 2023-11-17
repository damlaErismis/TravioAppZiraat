//
//  PlaceAnnotation.swift
//  TravioProject
//
//  Created by Burak Özer on 31.10.2023.
//

import Foundation
import MapKit

class CustomAnnotation: MKPointAnnotation {
    var mapItem:MKMapItem?
    var placeId: String?
    var visitDescription:String?
    var titlePlace:String?
    var image:String?
    var addedBy:String?
    var addedDate:String?
}
