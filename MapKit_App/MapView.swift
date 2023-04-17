//
//  MapView.swift
//  MapKit_App
//
//  Created by James Meegan on 4/14/23.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

    var startingLocation: String
    var destinationLocation: String
    var avoidTolls: Bool

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        // Get the coordinates for the starting and destination locations
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(startingLocation) { [weak mapView] (placemarks, error) in
            guard let mapView = mapView,
                  let placemark = placemarks?.first,
                  let startingCoordinate = placemark.location?.coordinate else {
                return
            }
            


            geocoder.geocodeAddressString(destinationLocation) { [weak mapView] (placemarks, error) in
                guard let mapView = mapView,
                      let placemark = placemarks?.first,
                      let destinationCoordinate = placemark.location?.coordinate else {
                    return
                }
                
                
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
                    
                    var annotations = [MKAnnotation]()
                    for route in response.routes {
                        mapView.addOverlay(route.polyline)
                        //                        let startingAnnotation = MKPointAnnotation()
                        //                        mapView.addAnnotation(startingAnnotation)
                        //                        annotations.append(startingAnnotation)
                        //                        let destinationAnnotation = MKPointAnnotation()
                        //                        destinationAnnotation.coordinate = destinationCoordinate
                        //                        destinationAnnotation.title = "Destination"
                        //                        mapView.addAnnotation(destinationAnnotation)
                        //                        annotations.append(destinationAnnotation)                    }
                        
                        mapView.showAnnotations(annotations, animated: true)
                    }
                }
            }
        }

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class BorderPolylineRenderer: MKPolylineRenderer {
        override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
            let borderWidth: CGFloat = 7.0
            let mainLineWidth: CGFloat = 5.5

            // Draw black polyline border
            self.lineWidth = borderWidth
            self.strokeColor = UIColor.black
            super.draw(mapRect, zoomScale: zoomScale, in: context)

            // Draw main polyline with desired color on top of the border
            self.lineWidth = mainLineWidth
            self.strokeColor = UIColor(red: 70/255, green: 153/255, blue: 255/255, alpha: 1.0)
            super.draw(mapRect, zoomScale: zoomScale, in: context)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = BorderPolylineRenderer(overlay: overlay)
            return renderer
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}

