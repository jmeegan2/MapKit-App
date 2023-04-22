//
//  InputView.swift
//  MapKit_App
//
//  Created by James Meegan on 4/8/23.
//
//Baltimore 39.284176, -76.622368
//San Francisco  37.773972, -122.431297
//Omaha, Nebraska 41.257160 Longitude: -95.995102

import SwiftUI
import MapKit

struct InputView: View {
    @StateObject private var viewModel = TripViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.isLoading {
                LoadingView()
            } else {
                Group {
                    LocationTextField(label: "Starting Location", text: $viewModel.startingLocation)
                    LocationTextField(label: "Destination Location", text: $viewModel.destinationLocation)
                    HStack {
                        ValueTextField(label: "Vehicle MPG", text: $viewModel.mpg)
                        Spacer()
                        ValueTextField(label: "Average Gas Price", text: $viewModel.averageGasPrice)
                    }

                    TogglesView(avoidTolls: $viewModel.avoidTolls, avoidHighways: $viewModel.avoidHighways)

                    Button(action: viewModel.calculateTripDetails) {
                        Text("Calculate")
                            .frame(maxWidth: .infinity)
                            .padding(.all, 10)
                            .foregroundColor(.white)
                            .background(Color(red: 30/255, green: 65/255, blue: 105/255))
                            .fontWeight(.bold)
                            .cornerRadius(10)
                    }
                }
                VStack(alignment: .leading, spacing: 10) {
                    ResultView(title: "Trip Duration:", value: viewModel.formatTime(viewModel.time))
                    ResultView(title: "Distance:", value: "\(Int(viewModel.distance)) miles")
                    ResultView(title: "Cost:", value: String(format: "$%.2f", viewModel.cost))
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)

                if (viewModel.showMapView) {
                    MapView(startingLocation: viewModel.startingLocation, destinationLocation: viewModel.destinationLocation, avoidTolls: viewModel.avoidTolls, avoidHighways: viewModel.avoidHighways)
                        .id(viewModel.mapIdentifier)
                    OpenInAppleMapsButton(action: viewModel.openInAppleMaps)
                } else {
                    Color.clear
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.alertMessage),
                  dismissButton: .default(Text("OK")) {
                viewModel.calculateButtonPressed = false // Set the button state back to false
                viewModel.distance = 0
                viewModel.time = 0
                viewModel.cost = 0
            })
        }
        .padding()
        .background(Color.white)
        .padding(.horizontal)
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}
