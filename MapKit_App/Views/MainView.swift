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
    @State private var showStartingLocationSearch = false
    @State private var showDestinationLocationSearch = false
    @FocusState private var isFocusedTextField: Bool
    @State private var showSearchResults: Bool = false
    var backgroundColor: Color = Color.init(uiColor: .systemGray6)
    var body: some View {
        ZStack{
        VStack(alignment: .leading) {
            if viewModel.isLoading {
                LoadingView()
            }else {
                Group {
                    ComponentLocationTextFieldView(label: "Starting Location", text: $viewModel.startingLocation)
                        .onTapGesture {
                            showStartingLocationSearch = true
                            showDestinationLocationSearch = false
                        }
                    
                    
                    ComponentLocationTextFieldView(label: "Destination Location", text: $viewModel.destinationLocation)
                        .onTapGesture {
                            showDestinationLocationSearch = true
                            showStartingLocationSearch = false
                        }
                    if showDestinationLocationSearch {
                        SearchAddressView(viewModel: viewModel, selectedAddress: $viewModel.destinationLocation, isShowing: $showDestinationLocationSearch)
                            .onChange(of: viewModel.destinationLocation) { _ in
                                showDestinationLocationSearch = false
                            }
                    }
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
                    ComponentResultView(title: "Distance:", value: "\(Int(viewModel.distance)) miles")
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
        if showStartingLocationSearch {
                        SearchAddressView(viewModel: viewModel, selectedAddress: $viewModel.startingLocation, isShowing: $showStartingLocationSearch)
                            .onChange(of: viewModel.startingLocation) { _ in
                                showStartingLocationSearch = false
                            }
                    }

                    if showDestinationLocationSearch {
                        SearchAddressView(viewModel: viewModel, selectedAddress: $viewModel.destinationLocation, isShowing: $showDestinationLocationSearch)
                            .onChange(of: viewModel.destinationLocation) { _ in
                                showDestinationLocationSearch = false
                            }
                    }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


