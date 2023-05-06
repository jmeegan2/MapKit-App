//
//  MapView.swift
//  MapKit_App
//
//  Created by James Meegan on 5/6/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var viewModel = MapViewModel()

    private let address: AddressResult
    
    init(address: AddressResult) {
        self.address = address
    }
    
    var body: some View {
        Map(
            coordinateRegion: $viewModel.region,
            annotationItems: viewModel.annotationItems,
            annotationContent: { item in
                MapMarker(coordinate: item.coordinate)
            }
        )
        .onAppear {
            self.viewModel.getPlace(from: address)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
