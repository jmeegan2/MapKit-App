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
    @State private var startingLocationLat = ""
    @State private var startingLocationLong = ""
    @State private var destinationLocationLat = ""
    @State private var destinationLocationLong = ""
    @State private var mpg = ""
    @State private var averageGasPrice = ""
    @State private var distance: Double = 0
    @State private var cost: Double = 0
    @State private var avoidTolls = false // Toggle state for avoiding tolls
    @State private var time: Double = 0
    @State private var startingCoordinate: CLLocationCoordinate2D?
    @State private var destinationCoordinate: CLLocationCoordinate2D?
    @State private var coordinatesUpdated = false
    @State private var mapCoordinates: (CLLocationCoordinate2D, CLLocationCoordinate2D)?
    @State private var mapIdentifier = UUID()
    @State private var showAlert = false
    @State private var alertMessage = ""

    
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
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
                
                Button(action: calculateDistance) {
                    Text("Calculate Distance")
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
            
            //Baltimore 39.284176, -76.622368
            //San Francisco  37.773972, -122.431297
            // Conditionally render the MapView when both startingCoordinate and destinationCoordinate are non-nil
            if let startingCoordinate = startingCoordinate, let destinationCoordinate = destinationCoordinate {
                MapView(startingCoordinate: startingCoordinate, destinationCoordinate: destinationCoordinate, avoidTolls: avoidTolls)
                    .id(mapIdentifier)
                Button(action: openInAppleMaps) {
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")) {
                    // Perform any additional actions if needed when the alert is dismissed
                  })
        }
        .padding()
        .background(Color.white)
        .padding(.horizontal)
    }
    func calculateDistance() {
        mapIdentifier = UUID()

        guard let startingLat = Double(startingLocationLat),
                  let startingLong = Double(startingLocationLong),
                  let destinationLat = Double(destinationLocationLat),
                  let destinationLong = Double(destinationLocationLong),
                  let mpg = Double(mpg),
                  let gasPrice = Double(averageGasPrice) else {
                alertMessage = "Invalid input, please check your values."
                showAlert = true
                return
            }

        let startingCoordinate = CLLocationCoordinate2D(latitude: startingLat, longitude: startingLong)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)

        self.startingCoordinate = startingCoordinate
        self.destinationCoordinate = destinationCoordinate

        let startingMapItem = MKMapItem(placemark: MKPlacemark(coordinate: startingCoordinate))
        let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))

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
    }
    
    func openInAppleMaps() {
        guard let startingLat = Double(startingLocationLat),
              let startingLong = Double(startingLocationLong),
              let destinationLat = Double(destinationLocationLat),
              let destinationLong = Double(destinationLocationLong) else {
            alertMessage = "Invalid input, please check your values."
            showAlert = true
            return
        }

        let startingCoordinate = CLLocationCoordinate2D(latitude: startingLat, longitude: startingLong)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)

        let startURL = "http://maps.apple.com/?saddr=\(startingCoordinate.latitude),\(startingCoordinate.longitude)"
        let destURL = "&daddr=\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)"
        let avoidTolls = self.avoidTolls ? "&dirflg=t" : ""

        let url = URL(string: startURL + destURL + avoidTolls)

        if let url = url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            alertMessage = "Failed to open Apple Maps."
            showAlert = true
        }
    }


        
    }
    
    
    struct InputView_Previews: PreviewProvider {
        static var previews: some View {
            InputView()
        }
    }

