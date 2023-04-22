//
//  MapView.swift
//  MapKit_App
//
//  Created by James Meegan on 4/14/23.
//

import SwiftUI
import MapKit

class StartingAnnotation: MKPointAnnotation {}

struct MapView: UIViewRepresentable {
    var startingLocation: String
    var destinationLocation: String
    var avoidTolls: Bool
    var avoidHighways: Bool

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = startingLocation
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak mapView] response, error in
            guard let mapView = mapView,
                  let response = response,
                  let mapItem = response.mapItems.first,
                  let startingCoordinate = mapItem.placemark.location?.coordinate else {
                      return
            }
            
            let destinationSearchRequest = MKLocalSearch.Request()
            destinationSearchRequest.naturalLanguageQuery = destinationLocation
            
            let destinationSearch = MKLocalSearch(request: destinationSearchRequest)
            destinationSearch.start { [weak mapView] response, error in
                guard let mapView = mapView,
                      let response = response,
                      let mapItem = response.mapItems.first,
                      let destinationCoordinate = mapItem.placemark.location?.coordinate else {
                          return
                }
                
                let destinationAnnotation = MKPointAnnotation()
                destinationAnnotation.coordinate = destinationCoordinate
                destinationAnnotation.title = destinationLocation
                
                let startingAnnotation = StartingAnnotation()
                startingAnnotation.coordinate = startingCoordinate
                startingAnnotation.title = startingLocation
                
                let directionRequest = MKDirections.Request()
                directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: startingCoordinate))
                directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
                directionRequest.transportType = .automobile
                
                if avoidTolls {
                    directionRequest.tollPreference = .avoid
                } else {
                    directionRequest.tollPreference = .any
                }
                
                if avoidHighways {
                    directionRequest.highwayPreference = .avoid
                } else {
                    directionRequest.highwayPreference = .any
                }
                
                let directions = MKDirections(request: directionRequest)
                directions.calculate { [weak mapView] response, error in
                    guard let response = response else { return }
                    
                    var annotations = [MKAnnotation]()
                    for route in response.routes {
                        let mainPolyline = route.polyline
                        mainPolyline.title = "main"
                        
                        let borderPolyline = route.polyline
                        mapView?.addOverlay(mainPolyline)
                        mapView?.insertOverlay(borderPolyline, below: mainPolyline)
                        mapView?.addAnnotation(destinationAnnotation)
                        mapView?.addAnnotation(startingAnnotation)
                        
                        var regionRect = mainPolyline.boundingMapRect
                        let wPadding = regionRect.size.width * 0.25
                        let hPadding = regionRect.size.height * 0.25
                        regionRect.size.width += wPadding
                        regionRect.size.height += hPadding
                        regionRect.origin.x -= wPadding / 2
                        regionRect.origin.y -= hPadding / 2
                        
                        mapView?.setRegion(MKCoordinateRegion(regionRect), animated: true)
                        
                        annotations.append(contentsOf: mapView?.annotations ?? [])
                    }
                    
                    mapView?.showAnnotations(annotations, animated: true)
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
        
        func resizeImage(image: UIImage, newSize: CGSize = CGSize(width: 10, height: 10)) -> UIImage {
            let renderer = UIGraphicsImageRenderer(size: newSize)
            let newImage = renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: newSize))
            }
            return newImage
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is StartingAnnotation {
                let reuseId = "customAnnotation"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)

                if annotationView == nil {
                           annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                           annotationView?.canShowCallout = true
                           if let startingImage = UIImage(named: "/Users/jamesmeegan/Desktop/softwareDev/mobileApp/MapKit_App/MapKit_App/Views/1200px-White_dot.svg.png") {
                               annotationView?.image = resizeImage(image: startingImage)
                           }
                       } else {
                           annotationView?.annotation = annotation
                       }

                       return annotationView
                   }

                   return nil
               }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = overlay.title == "main" ? UIColor(red: 24/255, green: 100/255, blue: 230/255, alpha: 1.0) : .black
                renderer.lineWidth = overlay.title == "main" ? 6 : 8
                renderer.lineCap = .round
                renderer.lineJoin = .bevel
                return renderer
                }
       
    }
    
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}