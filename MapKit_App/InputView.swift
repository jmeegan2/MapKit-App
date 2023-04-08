//
//  InputView.swift
//  MapKit_App
//
//  Created by James Meegan on 4/8/23.
//


//struct InputView: View {
//    //State declarations
//    @State private var startingLocation = ""
//    @State private var destinationLocation = ""
//    @State private var mpg = ""
//    @State private var distance: Double = 0
//    @State private var cost: Double = 0
//
//
//    var body: some View {
//        VStack(alignment: .center){
//            TextField("Starting location", text: $startingLocation)
//            TextField("Destination location", text: $destinationLocation)
//            TextField("Average MPG for vehicle", text: $mpg)
//            Button("Calculate Distance") {
//                // Calculate distance using Starting location and Destination location
//                // Set distance state variable
//                // Calculate cost using distance and national gas price average
//                // Set cost state variable
//            }
//            .frame(width: 100.0, height: 60.0)
//            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
//            Text("Distance: \(distance)")
//            Text("Cost: \(cost)")
//            Button("Preview Route") {
//                // Show MapView with starting and destination
//            }
//            .frame(width: 100.0, height: 60.0)
//            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
//
//        }
//    }
//}
//
//struct InputView_Previews: PreviewProvider {
//    static var previews: some View {
//        InputView()
//    }
//}

import SwiftUI
import MapKit

struct InputView: View {
    // State declarations
    @State private var startingLocationLat = ""
    @State private var startingLocationLong = ""
    @State private var destinationLocationLat = ""
    @State private var destinationLocationLong = ""
    @State private var mpg = ""
    @State private var distance: Double = 0
    @State private var cost: Double = 0
    
    
    var body: some View {
        VStack {
            // Create two text fields for starting and destination locations
            HStack {
                VStack(alignment: .leading) {
                    Text("Starting location")
                    TextField("Latitude", text: $startingLocationLat)
                    TextField("Longitude", text: $startingLocationLong)
                }
                
                VStack(alignment: .leading) {
                    Text("Destination location")
                    TextField("Latitude", text: $destinationLocationLat)
                    TextField("Longitude", text: $destinationLocationLong)
                }
            }
            
            // Create a text field for average MPG
            TextField("Average MPG for vehicle", text: $mpg)
            
            // Create a button to calculate distance and cost
            Button("Calculate Distance") {
                // Convert latitude and longitude strings to Double
                guard let startingLat = Double(startingLocationLat),
                      let startingLong = Double(startingLocationLong),
                      let destinationLat = Double(destinationLocationLat),
                      let destinationLong = Double(destinationLocationLong),
                      let mpg = Double(mpg) else {
                    return
                }
                
                // Create starting and destination coordinates
                let startingCoordinate = CLLocationCoordinate2D(latitude: startingLat, longitude: startingLong)
                let destinationCoordinate = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
                
                // Create map items for starting and destination locations
                let startingPlacemark = MKPlacemark(coordinate: startingCoordinate)
                let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
                
                let startingMapItem = MKMapItem(placemark: startingPlacemark)
                let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                
                // Calculate directions and distance between starting and destination locations
                let directionRequest = MKDirections.Request()
                directionRequest.source = startingMapItem
                directionRequest.destination = destinationMapItem
                directionRequest.transportType = .automobile
                
                let directions = MKDirections(request: directionRequest)
                
                directions.calculate { [self] (response, error) in
                    // Check if response is valid
                    guard let response = response else {
                        return
                    }
                    
                    // Get the first route in the response and calculate the distance
                    let route = response.routes[0]
                    let distanceInMeters = route.distance
                    self.distance = distanceInMeters / 1609.344 // Convert meters to miles
                    
                    // Calculate the cost based on distance and MPG
                    let nationalGasPriceAverage = 3.00 // Example gas price per gallon
                    self.cost = (self.distance / mpg) * nationalGasPriceAverage
                }
            }
            .frame(width: 100.0, height: 60.0)
            .border(Color.black, width: 1)
            
            // Display the distance and cost
            Text("Distance: \(distance, specifier: "%.2f") miles")
            Text("Cost: $\(cost, specifier: "%.2f")")
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
