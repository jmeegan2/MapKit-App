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
    var avoidHighways: Bool

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        
        // Get the coordinates for the starting and destination locations
           let searchRequest = MKLocalSearch.Request()
           searchRequest.naturalLanguageQuery = startingLocation

           let search = MKLocalSearch(request: searchRequest)
           search.start { [weak mapView] (response, error) in
               guard let mapView = mapView,
                   let response = response,
                   let mapItem = response.mapItems.first,
                   let startingCoordinate = mapItem.placemark.location?.coordinate else {
                   return
               }

               let destinationSearchRequest = MKLocalSearch.Request()
               destinationSearchRequest.naturalLanguageQuery = destinationLocation

               let destinationSearch = MKLocalSearch(request: destinationSearchRequest)
               destinationSearch.start { [weak mapView] (response, error) in
                   guard let mapView = mapView,
                       let response = response,
                       let mapItem = response.mapItems.first,
                       let destinationCoordinate = mapItem.placemark.location?.coordinate else {
                       return
                   }
                
                   
                   let destinationAnnotation = MKPointAnnotation()
                   destinationAnnotation.coordinate = destinationCoordinate
                   destinationAnnotation.title = destinationLocation
                   
                   let startingAnnotation = MKPointAnnotation()
                   startingAnnotation.coordinate = startingCoordinate
                   startingAnnotation.title = startingLocation
                   
                // Display the route on the map
                let directionRequest = MKDirections.Request()
                
                if avoidTolls {
                    directionRequest.tollPreference = .avoid // Avoid tolls
                } else {
                    directionRequest.tollPreference = .any
                }
                if avoidHighways {
                    directionRequest.highwayPreference = .avoid // Avoid highways
                } else {
                    directionRequest.highwayPreference = .any
                }

                
                directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: startingCoordinate))
                directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
                directionRequest.transportType = .automobile
                
                let directions = MKDirections(request: directionRequest)
                directions.calculate { response, error in
                    guard let response = response else { return }

                    let annotations = [MKAnnotation]()
                    for route in response.routes {
                        // Instantiate the main polyline
                        let mainPolyline = route.polyline
                        mainPolyline.title = "main"
                        // Instantiate the border polyline
                        let borderPolyline = route.polyline
                        mapView.addOverlay(mainPolyline)
                        //add border polyline
                        mapView.insertOverlay(borderPolyline, below: mainPolyline)
                        mapView.addAnnotation(destinationAnnotation)
                        // Zoom in on the polyline route
                        var regionRect = mainPolyline.boundingMapRect

                        let wPadding = regionRect.size.width * 0.25
                        let hPadding = regionRect.size.height * 0.25
                                    
                        // Add padding to the region
                        regionRect.size.width += wPadding
                        regionRect.size.height += hPadding
                                    
                        // Center the region on the line
                        regionRect.origin.x -= wPadding / 2
                        regionRect.origin.y -= hPadding / 2

                        mapView.setRegion(MKCoordinateRegion(regionRect), animated: true)
                        
                        mapView.showAnnotations(annotations, animated: true)
                    }
                }
            }
               
        }
     
        
        return mapView
        
    }

    func updateUIView(_ view: MKMapView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }


    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        
    

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           let renderer = MKPolylineRenderer(overlay: overlay)
            // Use different colors for the border and the main polyline
            renderer.strokeColor = overlay.title == "main" ? UIColor(red: 24/255, green: 100/255, blue: 230/255, alpha: 1.0) : .black
                // Make the border polyline bigger. Their difference will be like the borderWidth of the main polyline
                renderer.lineWidth = overlay.title == "main" ? 6 : 8
                // Other polyline customizations
                renderer.lineCap = .round
                renderer.lineJoin = .bevel
                return renderer
            
            //use destinationCoordinator
                }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
               if annotation is MKPointAnnotation {
                   let reuseId = "destination"
                   var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

                   if annotationView == nil {
                       annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                       annotationView?.canShowCallout = true
                   } else {
                       annotationView?.annotation = annotation
                   }

                   return annotationView
               }

               return nil
           }
        
       
    }
    
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}


