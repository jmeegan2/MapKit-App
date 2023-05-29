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
    @State private var isSplittingCost = false
    @State private var numberOfPeople: String = ""
    @State private var calculateCost = 0
    @State private var perPersonCostSection = false
    @State private var calculateCostString = ""
    @FocusState private var numOfPeopleField: Bool

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
                    Text("MPG:")
                    Text("\(viewModel.mpg)")
                    Text("Time:")
                    Text(viewModel.formatTime(viewModel.time))
                    
                }
            }
            
            Section(header: Text("Invoice").font(.title).fontWeight(.bold)) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
                    Text("Cost:")
                    Text(viewModel.cost) //this is a string
                    
                    
                    //Make button here that will say would you like to split cost
                    
                }
                Button(action: {
                    isSplittingCost.toggle()
                    
                }) {
                    Text("Click Here to Split Cost")
                }
                if isSplittingCost{
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
                        Text("Number of People:")
                        TextField("", text:$numberOfPeople )
                            .focused($numOfPeopleField)
                            .padding(.all, 7)
                            .background(Color("TextField"))
                            .cornerRadius(10)
                    }
                }
                
                //if they click on the button section below is show
                //If they click this then they will
                //similar to section above it will use a lazy v grid the number of people on left than will show cost per each person in right side
                
                // Calculate button
                if(!numberOfPeople.isEmpty){
                    Button(action: {
                        numOfPeopleField = false
                        let costValue = viewModel.costInvoice
                        let numberOfPeopleValue = Double(numberOfPeople)
                        if costValue > 0 && numberOfPeopleValue ?? 0 > 0 {
                            let calculatedCost = (costValue / (numberOfPeopleValue ?? 0))
                            calculateCostString = String(format: "%.2f", calculatedCost)
                            perPersonCostSection = true;
                        } else {
                            perPersonCostSection = false;
                        }
                    }) {
                        Text("Calculate")
                    }
                }
                if perPersonCostSection {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
                        Text("Cost Per Person:")
                        Text(calculateCostString) //this is a string
                        
                        
                        //Make button here that will say would you like to split cost
                        
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
    }
// Function to calculate cost based on number of people and cost value
func calculateCost(numberOfPeople: Int, costValue: Float) -> Float {
    return Float(numberOfPeople) / costValue
}

