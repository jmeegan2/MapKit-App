//
//  TripViewModel.swift
//  MapKit_App
//
//  Created by James Meegan on 4/20/23.
//
import SwiftUI
import Foundation
import MapKit

class TripViewModel: ObservableObject {
    
    // MARK: - Published Properties
       @Published var isLoading = false
       @Published var startingLocation = ""
       @Published var destinationLocation = ""
       @Published var mpg = ""
       @Published var averageGasPrice = ""
       @Published var distance: Double = 0
       @Published var cost: Double = 0
       @Published var avoidTolls = false
       @Published var avoidHighways = false
       @Published var time: Double = 0
       @Published var mapIdentifier = UUID()
       @Published var showAlert = false
    
       @Published var alertMessage = ""
       @Published var calculateButtonPressed = false
    
    @Published var showInfoAlert = false
       // MARK: - Computed Properties
       var showMapView: Bool {
           !showAlert && calculateButtonPressed && distance > 0
       }
       
       // MARK: - Functionns
       
    func handleTripCalculation() {
        calculateTripDetails()
    }
       func  openAppleMaps() {
           openInAppleMaps()
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
    
    
   
    // MARK: - Functions
  
    func calculateTripDetails() {
        calculateButtonPressed = true
        mapIdentifier = UUID()

        guard let mpg = Double(mpg),
              let gasPrice = Double(averageGasPrice)
        else {
            alertMessage = "Invalid input, please check your values."
            showAlert = true
            return
        }
        isLoading = true

        searchLocation(startingLocation) { [self] (startingPlacemark) in
            searchLocation(destinationLocation) { [self] (destinationPlacemark) in
                calculateRoute(from: startingPlacemark, to: destinationPlacemark, mpg: mpg, gasPrice: gasPrice)
            }
        }
    }

    func searchLocation(_ location: String, completion: @escaping (MKPlacemark) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = location

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response, let mapItem = response.mapItems.first {
                completion(MKPlacemark(coordinate: mapItem.placemark.coordinate))
            } else {
                self.alertMessage = "Failed to find location: \(location)"
                self.isLoading = false
                self.showAlert = true
            }
        }
    }

    func calculateRoute(from startingPlacemark: MKPlacemark, to destinationPlacemark: MKPlacemark, mpg: Double, gasPrice: Double) {
        let request = createRouteRequest(from: startingPlacemark, to: destinationPlacemark)
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            
            if let error = error {
                self.handleRouteCalculationError(error)
                return
            }
            
            guard let route = response?.routes.first else {
                self.handleRouteCalculationFailure()
                return
            }
            
            self.updateTripDetails(from: route, mpg: mpg, gasPrice: gasPrice)
        }
    }

    private func createRouteRequest(from startingPlacemark: MKPlacemark, to destinationPlacemark: MKPlacemark) -> MKDirections.Request {
        let startingItem = MKMapItem(placemark: startingPlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let request = MKDirections.Request()
        request.source = startingItem
        request.destination = destinationItem
        request.transportType = .automobile
        request.tollPreference = avoidTolls ? .avoid : .any
        request.highwayPreference = avoidHighways ? .avoid : .any
        
        return request
    }

    private func handleRouteCalculationError(_ error: Error) {
        alertMessage = "Failed to calculate route: \(error.localizedDescription)"
        print("Error calculating route: \(error.localizedDescription)")
        print("\nMore error description: \(error.self)")
        isLoading = false
        showAlert = true
    }

    private func handleRouteCalculationFailure() {
        alertMessage = "Failed to calculate route."
        isLoading = false
        showAlert = true
    }
    
  


    private func updateTripDetails(from route: MKRoute, mpg: Double, gasPrice: Double) {
        time = route.expectedTravelTime / 3600 // Convert seconds to hours
        distance = round(route.distance / 1609.344) // Convert meters to miles
        cost = (distance / mpg) * gasPrice
        
        print("\n\n")
        print("Expected travel time: \(String(format: "%.2f", time)) hours\n"
            + "Distance: \(String(format: "%.2f", route.distance / 1609.344)) miles\n"
            + "Cost: $\(String(format: "%.2f", cost))")
        print("\n\n")
        
        isLoading = false
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
    
    
    func fetchAverageGasPrice() {
        scrapePrice { [weak self] price in
            DispatchQueue.main.async {
                if let price = price {
                    self?.averageGasPrice = String(price)
                } else {
                    print("Failed to fetch average gas price")
                }
            }
        }
    }
    init() {
            fetchAverageGasPrice()
        }
    
    

}
