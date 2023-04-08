//
//  ContentView.swift
//  MapKit_App
//
//  Created by James Meegan on 4/8/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    let annotation = MKPointAnnotation()
    let annotationTwo = MKPointAnnotation()
    let saintPaulHospitalBC = MKPointAnnotation()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            //Baltimore, Maryland
            latitude: 39.2904,
            longitude: -76.6122
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03)
        )
        var body: some View {
            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.all)
        }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
