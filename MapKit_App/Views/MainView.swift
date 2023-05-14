//
//  InputView.swift
//  MapKit_App
//
//  Created by James Meegan on 4/8/23.
//


import SwiftUI
import MapKit

struct MainView: View {
    @StateObject private var viewModel = TripViewModel()
    @State var showAlert = false
    var body: some View {
        
            VStack(alignment: .leading) {
                if viewModel.isLoading {
                    LoadingView()
                }else {
                    Group {
                        Text(viewModel.locationString)
                        ComponentLocationTextFieldView(label: "Starting Location", text: $viewModel.startingLocation, viewModel: viewModel)
                        ComponentLocationTextFieldView(label: "Destination Location", text: $viewModel.destinationLocation, viewModel: viewModel)
    
                        HStack {
                            ComponentValueTextFieldView(label: "Vehicle MPG", text: $viewModel.mpg)
                            Spacer()
                            ComponentValueTextFieldView(
                                label: "Gas Price",
                                text: $viewModel.averageGasPrice,
                                showInfoIcon: true
                            )
                        }
                        ComponentRouteOptionsView(avoidTolls: $viewModel.avoidTolls, avoidHighways: $viewModel.avoidHighways)

                        Button(action: viewModel.calculateTripDetails) {
                            Text("Calculate")
                                .foregroundColor(Color("ButtonText"))
                                .frame(maxWidth: .infinity)
                                .padding(.all, 10)
                                .background(Color("Button"))
                                .fontWeight(.bold)
                                .cornerRadius(10)
                        }
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        ComponentResultView(title: "Trip Duration:", value: viewModel.formatTime(viewModel.time))
                        ComponentResultView(title: "Distance:", value: "\(String(viewModel.distanceDecimalOne)) miles")
                        ComponentResultView(title: "Cost:", value: String(format: "$%.2f", viewModel.cost))
                    }
                    

                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color("Results"))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    if (viewModel.showMapView) {
                        ComponentMapView(startingLocation: viewModel.startingLocation, destinationLocation: viewModel.destinationLocation, avoidTolls: viewModel.avoidTolls, avoidHighways: viewModel.avoidHighways)
                            .id(viewModel.mapIdentifier)
                        ComponentAppleMapsButton(action: viewModel.openInAppleMaps)
                    } else {
                        Color.clear
                    }
                }
            }
        
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Alert"),
                  message: Text(viewModel.alertMessage),
                  dismissButton: .default(Text("OK")) {
                viewModel.calculateButtonPressed = false // Set the button state back to false
                viewModel.distance = 0
                viewModel.time = 0
                viewModel.cost = 0
            })
        }
        .padding()
//        .background(Color.white)
        .padding(.horizontal)
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


