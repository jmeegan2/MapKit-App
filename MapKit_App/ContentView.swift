//
//  ContentView.swift
//  MapKit_App
//
//  Created by James Meegan on 4/8/23.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
   
    let locationManager = CLLocationManager()
    
    var startingCoordinate: CLLocationCoordinate2D
    var destinationCoordinate: CLLocationCoordinate2D
    var avoidTolls: Bool
    
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // Display the route on the map
        let directionRequest = MKDirections.Request()
        
        if avoidTolls {
                directionRequest.tollPreference = .avoid // Avoid tolls
            } else {
                directionRequest.tollPreference = .any
            }
        
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: startingCoordinate))
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let response = response else { return }
            
            for route in response.routes {
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
    }
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var mapView: MapView

    init(_ control: MapView) {
        self.mapView = control
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5
        return renderer
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
     InputView()
    }
}
