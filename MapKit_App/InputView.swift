//
//  InputView.swift
//  MapKit_App
//
//  Created by James Meegan on 4/8/23.
//
//Baltimore 39.284176, -76.622368
//San Francisco  37.773972, -122.431297
//Omaha, Nebraska 41.257160 Longitude: -95.995102

import SwiftUI
import MapKit

struct InputView: View {
    // State declarations
    @State private var startingLocation = ""
    @State private var destinationLocation = ""
    @State private var mpg = ""
    @State private var averageGasPrice = ""
    @State private var distance: Double = 0
    @State private var cost: Double = 0
    @State private var avoidTolls = false // Toggle state for avoiding tolls
    @State private var time: Double = 0
    @State private var mapIdentifier = UUID()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var calculateButtonPressed = false
    var showMapView: Bool {
      !showAlert && calculateButtonPressed
    }
    var body: some View {
        
        VStack(alignment: .leading) {
            Group {
                Text("Starting location")
                    .font(.headline)
                TextField("Starting location", text: $startingLocation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Destination location")
                    .font(.headline)
                TextField("Destination location", text: $destinationLocation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Vehicle MPG")
                    .font(.headline)
                TextField("Average MPG", text: $mpg)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Average Gas Price")
                    .font(.headline)
                TextField("Gas price per gallon", text: $averageGasPrice)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Toggle("Avoid tolls", isOn: $avoidTolls)
                    .padding(.vertical, 10)
                    .fontWeight(.bold)
                
                Button(action: calculateTripDetails ) {
                    Text("Calculate")
                        .frame(maxWidth: .infinity)
                        .padding(.all, 10.0)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .fontWeight(.bold)
                        .cornerRadius(10)
                }
            }
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
            
            if (showMapView) {
                MapView(startingLocation: startingLocation, destinationLocation: destinationLocation, avoidTolls: avoidTolls)
                    .id(mapIdentifier)
                Button(action: openInAppleMaps ) {
                    Text("Open in Apple Maps")
                        .frame(maxWidth: .infinity)
                        .padding(.all, 10.0)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .fontWeight(.bold)
                        .cornerRadius(10)
                }
            } else {
                Color.clear
            }
        }
        .alert(isPresented: $showAlert ) {
            Alert(title: Text("Error"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")) {
                calculateButtonPressed = false // Set the button state back to false
                distance = 0
                time = 0
                cost = 0
                
                        })
            
        }
        
        .padding()
        .background(Color.white)
        .padding(.horizontal)
    }
    func calculateTripDetails() {
        calculateButtonPressed = true
        mapIdentifier = UUID()

        guard let mpg = Double(mpg),
              let gasPrice = Double(averageGasPrice) else {
            alertMessage = "Invalid input, please check your values."
            showAlert = true
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(startingLocation) { [self] (startingPlacemarks, error) in
            if let startingPlacemark = startingPlacemarks?.first {
                geocoder.geocodeAddressString(destinationLocation) { [self] (destinationPlacemarks, error) in
                    if let destinationPlacemark = destinationPlacemarks?.first {
                        let startingCoordinate = startingPlacemark.location?.coordinate
                        let destinationCoordinate = destinationPlacemark.location?.coordinate
                        
                        let startingPlacemark = MKPlacemark(coordinate: startingCoordinate!)
                        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate!)

                        let startingMapItem = MKMapItem(placemark: startingPlacemark)
                        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

                        let directionRequest = MKDirections.Request()
                        directionRequest.source = startingMapItem
                        directionRequest.destination = destinationMapItem
                        directionRequest.transportType = .automobile
                        directionRequest.tollPreference = avoidTolls ? .avoid : .any

                        let directions = MKDirections(request: directionRequest)
                        directions.calculate { [self] (response, error) in
                            guard let response = response else {
                                return
                            }

                            let route = response.routes[0]
                            self.time = route.expectedTravelTime / 3600 // Convert seconds to hours
                            self.distance = route.distance / 1609.344 // Convert meters to miles

                            self.cost = (self.distance / mpg) * gasPrice
                        }
                    } else {
                        alertMessage = "Failed to geocode destination location."
                        showAlert = true
                    }
                }
            } else {
                alertMessage = "Failed to geocode starting location."
                showAlert = true
            }
        }
    }

    
    func openInAppleMaps() {
        guard let startingLocation = startingLocation.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let destinationLocation = destinationLocation.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            alertMessage = "Invalid input, please check your values."
            showAlert = true
            return
        }
        
        let startURL = "http://maps.apple.com/?saddr=\(startingLocation)"
        let destURL = "&daddr=\(destinationLocation)"
        let avoidTolls = self.avoidTolls ? "&dirflg=t" : ""
        
        let url = URL(string: startURL + destURL + avoidTolls)
        
        if let url = url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            alertMessage = "Failed to open Apple Maps."
            showAlert = true
        }
    }

    


        //End of view 
    }
    
    
    struct InputView_Previews: PreviewProvider {
        static var previews: some View {
            InputView()
        }
    }

