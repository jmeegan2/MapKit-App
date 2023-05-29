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
import CoreLocation

class TripViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    // MARK: - Published Properties
       @Published var isLoading = false
       @Published var startingLocation = ""
       @Published var destinationLocation = ""
       @Published var stringDistance = ""
       @Published var mpg = ""
       @Published var averageGasPrice = ""
       @Published var distance: Double = 0
       @Published var doubleDistanceValue: Double = 0
       @Published var cost = ""
    @Published var costInvoice: Double = 0

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
        }
       
    }
    
    
    func handleLocationString(_ locationString: String?) {
        // Handle the location string or pass it to the appropriate method in your TripViewModel
        DispatchQueue.main.async {
            if let locationString = locationString {
                self.locationString = locationString // Update locationString with the new value

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
        if time == 0 {
               return ""
           }
           
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .full
        
        let timeInterval = TimeInterval(time * 60 * 60)
        guard let formattedString = formatter.string(from: timeInterval) else {
            return ""
        }
        
        return formattedString
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
        UserDefaults.standard.set(mpg, forKey: "SavedMpg")
        isLoading = true
        print("starting location\(startingLocation)")
        searchLocation(startingLocation) { [self] (startingPlacemark) in
            searchLocation(destinationLocation) { [self] (destinationPlacemark) in
                calculateRoute(from: startingPlacemark, to: destinationPlacemark, mpg: mpg, gasPrice: gasPrice)
            }
        }
    }

    func loadSavedMpg() {
        let savedMpg = UserDefaults.standard.double(forKey: "SavedMpg")
        mpg = savedMpg != 0 ? String(savedMpg) : ""
    }
    
     func updateTripDetails(from route: MKRoute, mpg: Double, gasPrice: Double) {

        time = route.expectedTravelTime / 3600 // Convert seconds to hours
        distance = (route.distance / 1609.344) // Convert meters to miles
        if (distance > 10) {
            doubleDistanceValue = round(distance)
        } else {
            doubleDistanceValue = round(distance * 10) / 10
        }

          if doubleDistanceValue > 10 {
              stringDistance = String(format: "%.0f miles", doubleDistanceValue)
          } else {
              stringDistance = String(format: "%.1f miles", doubleDistanceValue)
          }
        cost = String(format: "$%.2f", (distance / mpg) * gasPrice) // Convert cost to string
        costInvoice = ((distance / mpg) * gasPrice)
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
                self.locationString = ""
            }
        }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    }
    
}




 


