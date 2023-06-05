//
//  MapViewModel.swift
//  MapKit_App
//
//  Created by James Meegan on 5/6/23.
//

import Foundation
import MapKit

class MapViewModelForSearchResults: ObservableObject {

    @Published var region = MKCoordinateRegion()
    
    func getPlace(from address: AddressResult) {
        var request = MKLocalSearch.Request()
        var title = address.title
        var subTitle = address.subtitle
        
        request.naturalLanguageQuery = subTitle.contains(title)
        ? subTitle : title + ", " + subTitle
    }
}
