//
//  SendInvoiceView.swift
//  MapKit_App
//
//  Created by James Meegan on 5/23/23.
//

import Foundation
import SwiftUI
import SwiftUIMessage
import MessageUI

struct SendInvoiceView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TripViewModel
    @State private var isSplittingCost = false
    @State private var numberOfPeople: String = ""
    @State private var calculateCost = 0
    @State private var perPersonCostSection = false
    @State private var calculateCostString = ""
    @FocusState private var numOfPeopleField: Bool
    @State private var showMailComposeView = false
    @State private var showMessageComposeView = false
    
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
                    Text(viewModel.cost) // this is a string
                }
                
                Button(action: {
                    isSplittingCost.toggle()
                }) {
                    Text("Click Here to Split Cost")
                        .multilineTextAlignment(.center)
                }
              
                Button(action: {
                    print("Mail clicked")
                    showMailComposeView.toggle()
                }) {
                    Image(systemName: "mail").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                }
                .sheet(isPresented: $showMailComposeView) {
                    if MFMailComposeViewController.canSendMail() {
                        MailComposeView(
                            .init(subject: "Subject",
                                  toRecipients: [
                                      "dummy@gmail.com"
                                  ],
                                  ccRecipients: nil,
                                  bccRecipients: nil,
                                  body: "This is an example email body.",
                                  bodyIsHTML: false,
                                  preferredSendingEmailAddress: nil)
                        )
                        .ignoresSafeArea()
                    } else {
                        Text("Mail cannot be sent from your device.")
                    }
                }
                    
                    Button(action: {
                        print("Message clicked")
                        
                    }){
                        Image(systemName: "message").resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                    }
              
                
                if isSplittingCost {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
                        Text("Number of People:")
                        TextField("", text: $numberOfPeople)
                            .focused($numOfPeopleField)
                            .padding(.all, 7)
                            .background(Color("TextField"))
                            .cornerRadius(10)
                    }
                }
                
                if !numberOfPeople.isEmpty {
                    Button(action: {
                        numOfPeopleField = false
                        let costValue = viewModel.costInvoice
                        let numberOfPeopleValue = Double(numberOfPeople)
                        if costValue > 0 && numberOfPeopleValue ?? 0 > 0 {
                            let calculatedCost = (costValue / (numberOfPeopleValue ?? 0))
                            calculateCostString = String(format: "%.2f", calculatedCost)
                            perPersonCostSection = true
                        } else {
                            perPersonCostSection = false
                        }
                    }) {
                        Text("Calculate")
                            .multilineTextAlignment(.center)
                    }
                }
                
                if perPersonCostSection {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
                        Text("Cost Per Person:")
                        Text(calculateCostString) // this is a string
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


