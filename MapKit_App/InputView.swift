//
//  InputView.swift
//  MapKit_App
//
//  Created by James Meegan on 4/8/23.
//
//Baltimore 39.284176, -76.622368
//San Francisco  37.773972, -122.431297


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
    @State private var avoidTolls = false // Toggle state for avoiding tolls
    @State private var time: Double = 0
    

    
    var body: some View {
        VStack {
            Group {
                VStack(alignment: .leading) {
                    Text("Starting location")
                        .font(.headline)
                    HStack {
                        TextField("Latitude", text: $startingLocationLat)
                        TextField("Longitude", text: $startingLocationLong)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Destination location")
                        .font(.headline)
                    HStack {
                        TextField("Latitude", text: $destinationLocationLat)
                        TextField("Longitude", text: $destinationLocationLong)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                     Text("Vehicle")
                    .font(.headline)
                TextField("Average MPG", text: $mpg)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    Toggle("Avoid tolls", isOn: $avoidTolls)
                        .padding(.vertical, 10)
                    Button("Calculate Distance", action:calculateDistance)
                        .padding(.all, 10.0)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(.blue)
                        .fontWeight(.bold)
                        .cornerRadius(10)
                    Group {

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Trip Duration:")
                                    .font(.headline)
                                Spacer()
                                Text("\(time, specifier: "%.2f") hours")
                            }
                            HStack {
                                Text("Distance:")
                                    .font(.headline)
                                Spacer()
                                Text("\(distance, specifier: "%.2f") miles")
                            }
                            HStack {
                                Text("Cost:")
                                    .font(.headline)
                                Spacer()
                                Text("$\(cost, specifier: "%.2f")")
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                //Baltimore 39.284176, -76.622368
                //San Francisco  37.773972, -122.431297
                Group {MapView()}
            }
            .padding()
            .background(Color.white)
            .padding(.horizontal)
            Spacer()
           
        }
        
            
        }
    func calculateDistance() {
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
        //If else for toggle avoidTolls boolean value
        if (avoidTolls) {
            directionRequest.tollPreference = .avoid // Avoid tolls
        } else {
            directionRequest.tollPreference = .any
        }
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { [self] (response, error) in
            // Check if response is valid
            guard let response = response else {
                return
            }
            
            // Get the first route in the response and calculate the distance
            let route = response.routes[0]
            let distanceInMeters = route.distance
            self.time = route.expectedTravelTime / 60 / 60// Convert seconds to minutes
            self.distance = distanceInMeters / 1609.344 // Convert meters to miles
            
            // Calculate the cost based on distance and MPG
            let nationalGasPriceAverage = 3.00 // Example gas price per gallon
            self.cost = (self.distance / mpg) * nationalGasPriceAverage
        }
    }

    }


struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
