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
    @State private var isLoading = false
    @State private var startingLocation = ""
    @State private var destinationLocation = ""
    @State private var mpg = ""
    @State private var averageGasPrice = ""
    @State private var distance: Double = 0
    @State private var cost: Double = 0
    @State private var avoidTolls = false // Toggle state for avoiding tolls
    @State private var avoidHighways = false // Toggle state for avoiding highways
    @State private var time: Double = 0
    @State private var mapIdentifier = UUID()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var calculateButtonPressed = false
    var showMapView: Bool {
      !showAlert && calculateButtonPressed && distance > 0
    }
    var body: some View {
        
        VStack(alignment: .leading) {
        
            if (isLoading ) {
                LoadingView()
            } else {
                Group {
                    Text("Starting Location")
                        .font(.headline)
                    TextField("Starting Location", text: $startingLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Destination Location")
                        .font(.headline)
                    TextField("Destination Location", text: $destinationLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Vehicle MPG")
                                .font(.headline)
                            TextField("MPG", text: $mpg)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Average Gas Price")
                                .font(.headline)
                            TextField("Per Gallon", text: $averageGasPrice)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    VStack{
                        Toggle("Avoid Tolls", isOn: $avoidTolls)
                            .padding(.vertical, 2)
                            .fontWeight(.bold)
                        Toggle("Avoid Highways", isOn: $avoidHighways)
                            .padding(.vertical, 2)
                            .fontWeight(.bold)
                        
                    }
                    Button(action: {
                        calculateTripDetails()
                    }) {
                        Text("Calculate")
                            .frame(maxWidth: .infinity)
                            .padding(.all, 10.0)
                            .foregroundColor(.white)
                            .background(Color(red: 30/255, green: 65/255, blue: 105/255))
                            .fontWeight(.bold)
                            .cornerRadius(10)
                    }
                }
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Trip Duration:")
                            .font(.headline)
                        Spacer()
                        Text("\(formatTime(time))")
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
                    MapView(startingLocation: startingLocation, destinationLocation: destinationLocation, avoidTolls: avoidTolls, avoidHighways: avoidHighways)
                        .id(mapIdentifier)
                    Button(action: openInAppleMaps ) {
                        Text("Open in Apple Maps")
                            .frame(maxWidth: .infinity)
                            .padding(.all, 10.0)
                            .foregroundColor(.white)
                            .background(Color(red: 30/255, green: 65/255, blue: 105/255))
                            .fontWeight(.bold)
                            .cornerRadius(10)
                    }
                } else {
                    Color.clear
                }
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
    
    func formatTime(_ time: Double) -> String {
        if time >= 24 {
            let days = Int(time / 24)
            let hours = Int(time.truncatingRemainder(dividingBy: 24))
            return "\(days) day\(days == 1 ? "" : "s") \(hours) hour\(hours == 1 ? "" : "s")"
        } else if time < 1 {
            let minutes = Int(ceil(time * 60))
            return "\(minutes) minute\(minutes == 1 ? "" : "s")"
        } else {
            let hours = Int(time)
            let minutes = Int(ceil((time - Double(hours)) * 60))
            return "\(hours) hour\(hours == 1 ? "" : "s") \(minutes) minute\(minutes == 1 ? "" : "s")"
        }
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
        isLoading = true
        
        geocodeStartingLocation { [self] (startingPlacemark) in
            geocodeDestinationLocation { [self] (destinationPlacemark) in
                calculateRoute(from: startingPlacemark, to: destinationPlacemark, mpg: mpg, gasPrice: gasPrice)
            }
        }
        
    }

    func geocodeStartingLocation(completion: @escaping (CLPlacemark) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(startingLocation) { (startingPlacemarks, error) in
            if let startingPlacemark = startingPlacemarks?.first {
                completion(startingPlacemark)
            } else {
                alertMessage = "Failed to geocode starting location."
                isLoading = false
                showAlert = true
            }
        }
    }

    func geocodeDestinationLocation(completion: @escaping (CLPlacemark) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(destinationLocation) { (destinationPlacemarks, error) in
            if let destinationPlacemark = destinationPlacemarks?.first {
                completion(destinationPlacemark)
            } else {
                alertMessage = "Failed to geocode destination location."
                isLoading = false
                showAlert = true
            }
        }
    }

    func calculateRoute(from startingPlacemark: CLPlacemark, to destinationPlacemark: CLPlacemark, mpg: Double, gasPrice: Double) {
        let startingItem = MKMapItem(placemark: MKPlacemark(coordinate: startingPlacemark.location!.coordinate))
        let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: destinationPlacemark.location!.coordinate))

        let request = MKDirections.Request()
        request.source = startingItem
        request.destination = destinationItem
        request.transportType = .automobile
        request.tollPreference = avoidTolls ? .avoid : .any
        request.highwayPreference = avoidHighways ? .avoid : .any

        MKDirections(request: request).calculate { [self] response, error in
            guard let route = response?.routes.first else {
                if let error = error {
                    alertMessage = "Failed to calculate route: \(error.localizedDescription)"
                } else {
                    alertMessage = "Failed to calculate route."
                }
                isLoading = false
                showAlert = true
                return
            }
            self.time = route.expectedTravelTime / 3600 // Convert seconds to hours
            self.distance = route.distance / 1609.344 // Convert meters to miles
            self.cost = (self.distance / mpg) * gasPrice
            
            isLoading = false
        }
    }


    
    func openInAppleMaps() {
        guard let startingLocation = startingLocation.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let destinationLocation = destinationLocation.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            alertMessage = "Invalid input, please check your values."
            showAlert = true
            isLoading = false
            return
        }
        
        let startURL = "http://maps.apple.com/?saddr=\(startingLocation)"
        let destURL = "&daddr=\(destinationLocation)"
        //these dont seem to pass atm, well read the documentation
        let avoidTolls = self.avoidTolls ? "&dirflg=t" : ""
        let avoidHighways = self.avoidHighways ? "&exclHwy=true" : ""
        let url = URL(string: startURL + destURL + avoidTolls + avoidHighways )
        
        if let url = url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            alertMessage = "Failed to open Apple Maps."
            showAlert = true
            isLoading = false
        }
    }

    


        //End of view 
    }



    
    
    struct InputView_Previews: PreviewProvider {
        static var previews: some View {
            InputView()
        }
    }




