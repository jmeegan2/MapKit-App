////
////  InputFunctions.swift
////  MapKit_App
////
////  Created by James Meegan on 4/17/23.
////
//
//import Foundation
//
//public func formatTime(_ time: Double) -> String {
//    if time >= 24 {
//        let days = Int(time / 24)
//        let hours = Int(time.truncatingRemainder(dividingBy: 24))
//        return "\(days) day\(days == 1 ? "" : "s") \(hours) hour\(hours == 1 ? "" : "s")"
//    } else if time < 1 {
//        let minutes = Int(ceil(time * 60))
//        return "\(minutes) minute\(minutes == 1 ? "" : "s")"
//    } else {
//        let hours = Int(time)
//        let minutes = Int(ceil((time - Double(hours)) * 60))
//        return "\(hours) hour\(hours == 1 ? "" : "s") \(minutes) minute\(minutes == 1 ? "" : "s")"
//    }
//}
//
//
//public func calculateTripDetails() {
//    calculateButtonPressed = true
//    mapIdentifier = UUID()
//
//    guard let mpg = Double(mpg),
//          let gasPrice = Double(averageGasPrice) else {
//        alertMessage = "Invalid input, please check your values."
//        showAlert = true
//        return
//    }
//    isLoading = true
//
//    searchLocation(startingLocation) { [self] (startingPlacemark) in
//        searchLocation(destinationLocation) { [self] (destinationPlacemark) in
//            calculateRoute(from: startingPlacemark, to: destinationPlacemark, mpg: mpg, gasPrice: gasPrice)
//        }
//    }
//}
//
//public func searchLocation(_ location: String, completion: @escaping (MKPlacemark) -> Void) {
//    let request = MKLocalSearch.Request()
//    request.naturalLanguageQuery = location
//
//    let search = MKLocalSearch(request: request)
//    search.start { (response, error) in
//        if let response = response, let mapItem = response.mapItems.first {
//            completion(MKPlacemark(coordinate: mapItem.placemark.coordinate))
//        } else {
//            alertMessage = "Failed to find location: \(location)"
//            isLoading = false
//            showAlert = true
//        }
//    }
//}
//
//public func calculateRoute(from startingPlacemark: MKPlacemark, to destinationPlacemark: MKPlacemark, mpg: Double, gasPrice: Double) {
//
//    // Initializations
//    let startingItem = MKMapItem(placemark: startingPlacemark)
//    let destinationItem = MKMapItem(placemark: destinationPlacemark)
//    let request = MKDirections.Request()
//
//    request.source = startingItem
//    request.destination = destinationItem
//    request.transportType = .automobile
//    request.tollPreference = avoidTolls ? .avoid : .any
//    request.highwayPreference = avoidHighways ? .avoid : .any
//
//    // Print statements
//    print("\n\nCalculating Route information")
//    print("Starting item: \(startingItem)")
//    print("Destination item: \(destinationItem)")
//    print("Request source: \(String(describing: request.source))")
//    print("Request destination: \(String(describing: request.destination))")
//    print("Request transport type: \(request.transportType)")
//    print("Request toll preference: \(request.tollPreference)")
//    print("Request highway preference: \(request.highwayPreference)")
//    
//    
//    MKDirections(request: request).calculate { [self] response, error in
//       
//        guard let route = response?.routes.first else {
//            if let error = error {
//                alertMessage = "Failed to calculate route: \(error.localizedDescription)"
//                print("Error calculating route: \(error.localizedDescription)")
//                print("\nMore error description: \(error.self)")
//                isLoading = false
//                showAlert = true
//                return
//            } else {
//                alertMessage = "Failed to calculate route."
//            }
//            isLoading = false
//            showAlert = true
//            return
//        }
//        self.time = route.expectedTravelTime / 3600 // Convert seconds to hours
//        
//        self.distance = (round(route.distance / 1609.344))
//// Convert meters to miles
//        self.cost = (self.distance / mpg) * gasPrice
//
//        print("\n\n")
//        print("Expected travel time: \(String(format: "%.2f", self.time)) hours\n"
//              + "Distance: \(String(format: "%.2f", route.distance / 1609.344)) miles\n"
//              + "Cost: $\(String(format: "%.2f", self.cost))")
//        print("\n\n")
//        isLoading = false
//    }
//}
//
//public func openInAppleMaps() {
//    guard let startingLocation = startingLocation.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
//          let destinationLocation = destinationLocation.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
//        alertMessage = "Invalid input, please check your values."
//        showAlert = true
//        isLoading = false
//        return
//    }
//    let startURL = "http://maps.apple.com/?saddr=\(startingLocation)"
//    let destURL = "&daddr=\(destinationLocation)"
//    let avoidTolls = self.avoidTolls ? "&dirflg=t" : ""
//    let avoidHighways = self.avoidHighways ? "&exclHwy=true" : ""
//    let url = URL(string: startURL + destURL + avoidTolls + avoidHighways )
//
//    if let url = url {
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//    } else {
//        alertMessage = "Failed to open Apple Maps."
//        showAlert = true
//        isLoading = false
//    }
//}
//    //End of view
//}
