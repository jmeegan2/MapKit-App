//
//  TripViewModel.swift
//  MapKit_App
//
//  Created by James Meegan on 4/20/23.
//
import SwiftUI
import Foundation
import MapKit
import Foundation
import SwiftSoup

class TripViewModel: NSObject, ObservableObject {
    
    // MARK: - Published Properties
       @Published var isLoading = false
       @Published var startingLocation = ""
       @Published var destinationLocation = ""
       @Published var mpg = ""
       @Published var averageGasPrice = ""
       @Published var distance: Double = 0
       @Published var distanceDecimalOne: Double = 0
       @Published var cost: Double = 0
       @Published var avoidTolls = false
       @Published var avoidHighways = false
       @Published var time: Double = 0
       @Published var mapIdentifier = UUID()
       @Published var showAlert = false
       @Published var alertMessage = ""
       @Published var calculateButtonPressed = false
       @Published var showInfoAlert = false
       var showMapView: Bool {
           !showAlert && calculateButtonPressed && distance > 0
       }
    @Published var locationString = ""

        // MARK: -USER LOCATION
        private let locationManager = CLLocationManager()
        @Published var userLocation: CLLocation?
        @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined

        override init() {
            super.init()
           
            self.locationManager.delegate = self
                   self.locationManager.requestWhenInUseAuthorization()
                   self.locationManager.startUpdatingLocation()
        }

        public func requestAuthorisation(always: Bool = false) {
            if always {
                self.locationManager.requestAlwaysAuthorization()
            } else {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [self] placemarks, error in
                if let placemark = placemarks?.first {
                    let locationString = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? "")"
                    
                    // Handle the location string or pass it to the appropriate method in your TripViewModel
                    self.handleLocationString(locationString)
                } else {
                    // Failed to reverse geocode location
                    handleLocationString(nil)
                
                }
            }
            print("USER LOCATION \(location)")
        }
       
    }
    
    
    func handleLocationString(_ locationString: String?) {
        // Handle the location string or pass it to the appropriate method in your TripViewModel
        DispatchQueue.main.async {
            if let locationString = locationString {
                print("User Location: \(locationString)")
                self.locationString = locationString // Update locationString with the new value

            } else {
                print("User location is unavailable.")
            }
        }
    }



    

    // MARK: - MKLocalSearchCompleter
      @Published var results: Array<AddressResult> = []
      @Published var searchableText = ""

      private lazy var localSearchCompleter: MKLocalSearchCompleter = {
          let completer = MKLocalSearchCompleter()
          completer.delegate = self
          return completer
          
      }()
      
      func searchAddress(_ searchableText: String) {
          guard searchableText.isEmpty == false else { return }
          localSearchCompleter.queryFragment = searchableText
      }
    

   // MARK: -Trip Details
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
            let minutes = Int(round(time * 60))
            return "\(minutes) minute\(minutes == 1 ? "" : "s")"
        } else {
            let hours = Int(time)
            let minutes = Int((time - Double(hours)).truncatingRemainder(dividingBy: 1) * 60)
            return "\(hours) hour\(hours == 1 ? "" : "s") \(minutes) minute\(minutes == 1 ? "" : "s")"
        }
    }
  
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
        print("\n\nSTARTING LOCATION: \(startingLocation)\n\n")
        searchLocation(startingLocation) { [self] (startingPlacemark) in
            searchLocation(destinationLocation) { [self] (destinationPlacemark) in
                calculateRoute(from: startingPlacemark, to: destinationPlacemark, mpg: mpg, gasPrice: gasPrice)
            }
        }
    }
    
    private func updateTripDetails(from route: MKRoute, mpg: Double, gasPrice: Double) {
        time = route.expectedTravelTime / 3600 // Convert seconds to hours
        print(route.expectedTravelTime)
        print("this is distance \(route.distance)")
        distance = (route.distance / 1609.344) // Convert meters to miles
        distanceDecimalOne = round(distance * 100) / 100.0
        
        cost = (distance / mpg) * gasPrice
        isLoading = false
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
        isLoading = false
        showAlert = true
    }

    private func handleRouteCalculationFailure() {
        alertMessage = "Failed to calculate route."
        isLoading = false
        showAlert = true
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
    
}


 // MARK: - Extension MKLocalSearchCompleter
extension TripViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        Task { @MainActor in
            if(locationString.isEmpty) {
                results = completer.results.map {
                                return AddressResult(title: $0.title, subtitle: $0.subtitle)
                            }
            } else {
                var resultsArray = [AddressResult(title: "Current Location", subtitle: locationString)]
               
                resultsArray += completer.results.map { AddressResult(title: $0.title, subtitle: $0.subtitle) }
                
                results = resultsArray
                
            }
        }
    }
    
    func checkAddressAndModifyLocationString(addressTitle: String) {
            if (addressTitle == "Current Location") {
                print("you clicked your location")
                self.locationString = ""
            }
        }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    }
    
    
}




extension TripViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
    }
}


