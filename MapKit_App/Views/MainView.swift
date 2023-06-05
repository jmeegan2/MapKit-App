//
//  InputView.swift
//  MapKit_App
//
//  Created by James Meegan on 4/8/23.
//


import SwiftUI
import MapKit

struct MainView: View {
    @StateObject private var viewModel_Main = TripViewModel()
    
    
    @State var showAlert = false
    @State var isHiPageVisible = false // Track the visibility of the "hi" page
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if viewModel_Main.isLoading {
                LoadingView()
            }else {
                
                Group {
                    HStack{
                        Spacer()
                        Button(action: {isHiPageVisible = true}, label: {
                            Image(systemName: "paperplane").resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)})
                    }
                    ComponentLocationTextFieldView(label: "Starting Location", text: $viewModel_Main.startingLocation, viewModel: viewModel_Main)
                    ComponentLocationTextFieldView(label: "Destination Location", text: $viewModel_Main.destinationLocation, viewModel: viewModel_Main)
                    
                    HStack {
                        ComponentValueTextFieldView(label: "Vehicle MPG", text: $viewModel_Main.mpg)
                        Spacer()
                        ComponentValueTextFieldView(
                            label: "Gas Price",
                            text: $viewModel_Main.averageGasPrice,
                            showInfoIcon: true
                        )
                    }
                    ComponentRouteOptionsView(avoidTolls: $viewModel_Main.avoidTolls, avoidHighways: $viewModel_Main.avoidHighways)
                    
                    Button(action: viewModel_Main.calculateTripDetails) {
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
                    ComponentResultView(title: "Trip Duration:", value: viewModel_Main.formatTime(viewModel_Main.time))
                    ComponentResultView(title: "Distance:", value: "\((viewModel_Main.stringDistance))")
                    ComponentResultView(title: "Cost:", value:  (viewModel_Main.cost))
                }
                
                
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color("Results"))
                .cornerRadius(10)
                .shadow(radius: 5)
                if (viewModel_Main.showMapView) {
                    ComponentMapView(startingLocation: viewModel_Main.startingLocation, destinationLocation: viewModel_Main.destinationLocation, avoidTolls: viewModel_Main.avoidTolls, avoidHighways: viewModel_Main.avoidHighways)
                        .id(viewModel_Main.mapIdentifier)
                    ComponentAppleMapsButtonView(action: viewModel_Main.openInAppleMaps)
                } else {
                    Color.clear
                }
            }
        }
        .onAppear {
            viewModel_Main.loadSavedMpg()
        }
        .fullScreenCover(isPresented: $isHiPageVisible) {
            SendInvoiceView(viewModel_Main: viewModel_Main)
            
        }
        
        .alert(isPresented: $viewModel_Main.showAlert) {
            Alert(title: Text("Alert"),
                  message: Text(viewModel_Main.alertMessage),
                  dismissButton: .default(Text("OK")) {
                viewModel_Main.calculateButtonPressed = false // Set the button state back to false
                viewModel_Main.stringDistance = ""
                viewModel_Main.time = 0
                viewModel_Main.cost = ""
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


