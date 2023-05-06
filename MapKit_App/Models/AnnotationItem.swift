//
//  AnnotationItem.swift
//  MapKit_App
//
//  Created by James Meegan on 5/6/23.
//

import Foundation
import CoreLocation

struct AnnotationItem: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
