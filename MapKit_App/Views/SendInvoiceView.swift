//
//  SendInvoiceView.swift
//  MapKit_App
//
//  Created by James Meegan on 5/23/23.
//

import Foundation
import SwiftUI

struct SendInvoiceView: View {
    @Environment(\.presentationMode) var presentationMode
        @ObservedObject var viewModel: TripViewModel

        var body: some View {
            Form {
                Section(header: Text("Trip Details").font(.title).fontWeight(.bold)) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
                        Text("From:")
                        Text(viewModel.startingLocation)
                        Text("To:")
                        Text(viewModel.destinationLocation)
                        Text("\nDistance:")
                        Text("\n\(viewModel.stringDistance)")
                        Text("Time:")
                        Text(viewModel.formatTime(viewModel.time))
                        
                    }
                }

                Section(header: Text("Invoice").font(.title).fontWeight(.bold)) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
                        Text("Cost:")
                        Text(viewModel.cost)
                        
                    }
                }
                
         
            }
            Spacer()
            Button(action: {
                presentationMode.wrappedValue.dismiss() // Close the screen
            }) {
                Text("Close")
                    .foregroundColor(Color("ButtonText"))
                    .background(Color("Button"))
                    .frame(maxWidth: .infinity)
                    .padding(.all, 10.0)
                    .foregroundColor(.white)
                    .background(Color("Button"))
                    .fontWeight(.bold)
                    .cornerRadius(10)
            }
            .padding()
            .navigationBarTitle(Text("Invoice View"), displayMode: .inline)
        }
    }
