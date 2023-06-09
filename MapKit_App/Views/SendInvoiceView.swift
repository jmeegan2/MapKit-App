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
    @ObservedObject var viewModel_Main: TripViewModel
    @StateObject var viewModel_Invoice = InvoiceViewModel()
    
    @State private var numberOfPeople: String = ""
    @State private var calculateCost = 0
    @State private var calculateCostString = ""
    @FocusState private var numOfPeopleField: Bool
    @State private var showMailComposeView = false
    @State private var showMessageComposeView = false
    
    var body: some View {
        Form {
            
            
            Section(header: Text("Trip Details").font(.title).fontWeight(.bold)) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
                    Text("From:")
                    Text(viewModel_Main.startingLocation)
                    Text("To:")
                    Text(viewModel_Main.destinationLocation)
                    Text("\nDistance:")
                    Text("\n\(viewModel_Main.stringDistance)")
                    Text("MPG:")
                    Text("\(viewModel_Main.mpg)")
                    Text("Cost:")
                    Text(viewModel_Main.cost) // this is a string
                    
                }
                Button(action: {
                    viewModel_Invoice.isSplittingCost.toggle()
                }) {
                    Text("Click Here to Split Cost")
                        .multilineTextAlignment(.center)
                }.frame(maxWidth: .infinity)
                if viewModel_Invoice.isSplittingCost {
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10){
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
                        viewModel_Invoice.calculateCost(costValue: viewModel_Main.costInvoice, numberOfPeopleValue: Double(numberOfPeople))
                    }) {
                        Text("Calculate")
                            .multilineTextAlignment(.center)
                    }.frame(maxWidth: .infinity)
                }
                
                if viewModel_Invoice.perPersonCostSection {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
                        Text("Cost Per Person:")
                        Text("$\(viewModel_Invoice.calculateCostString)")
                    }
                }
            }
                
                
                
                Section(header: Text("Invoice").font(.title).fontWeight(.bold)) {
                    
                    
                    Button(action: {
                        showMailComposeView.toggle()
                    }) {
                        HStack {
                            Image(systemName: "mail")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                            Text("Email Invoice")
                        }
                    }
                    .sheet(isPresented: $showMailComposeView) {
                        if MFMailComposeViewController.canSendMail() {
                            let messageBodyMail = """
                        <html>
                        <head>
                        <style>
                        body {
                            font-family: Arial, sans-serif;
                            font-size: 14px;
                            line-height: 1.5;
                        }
                        p {
                            margin: 0;
                            padding: 0;
                        }
                        .header {
                            font-size: 18px;
                            font-weight: bold;
                            margin-bottom: 10px;
                        }
                        .details {
                            margin-bottom: 20px;
                        }
                        </style>
                        </head>
                        <body>
                        <p class="header">Gas Route Invoice</p>
                        <div class="details">
                            <p>Date: \(viewModel_Invoice.formattedDate)</p>
                            <p>From: \(viewModel_Main.startingLocation)</p>
                            <p>To: \(viewModel_Main.destinationLocation)</p>
                            <p>Distance: \(viewModel_Main.stringDistance)</p>
                            <p>MPG: \(viewModel_Main.mpg)</p>
                            <p>Time: \(viewModel_Main.formatTime(viewModel_Main.time))</p>
                            <p>Cost: \(viewModel_Main.cost)</p>
                            <p>\(viewModel_Invoice.sendInvoiceNumberOfPeople)</p>
                            <p>\(viewModel_Invoice.sendInvoiceCostPerPerson)</p>
                        </div>
                        </body>
                        </html>
                        """
                            MailComposeView(
                                .init(subject: "Gas Route Invoice",
                                      toRecipients: [""],
                                      ccRecipients: nil,
                                      bccRecipients: nil,
                                      body: messageBodyMail,
                                      bodyIsHTML: true,
                                      preferredSendingEmailAddress: nil)
                            )
                            .ignoresSafeArea()
                        } else {
                            Text("Mail cannot be sent from your device.")
                        }
                    }
                    
                    Button(action: {
                        showMessageComposeView.toggle()
                    }) {
                        HStack {
                            Image(systemName: "message")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                            Text("Message Invoice")
                        }
                    }
                    .sheet(isPresented: $showMessageComposeView) {
                        if MFMessageComposeViewController.canSendText() {
                            let messageBodyText = """
                        ** Gas Route Invoice **
                        
                        Date: \(viewModel_Invoice.formattedDate)
                        From: \(viewModel_Main.startingLocation)
                        To: \(viewModel_Main.destinationLocation)
                        Distance: \(viewModel_Main.stringDistance)
                        MPG: \(viewModel_Main.mpg)
                        Time: \(viewModel_Main.formatTime(viewModel_Main.time))
                        Cost: \((viewModel_Main.cost))
                        \((viewModel_Invoice.sendInvoiceNumberOfPeople))
                        \((viewModel_Invoice.sendInvoiceCostPerPerson))
                        """
                            
                            MessageComposeView(
                                .init(recipients: [""],
                                      body: messageBodyText)
                            )
                            .ignoresSafeArea()
                        } else {
                            Text("Message cannot be sent from your device.")
                        }
                    }
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Close the screen
                }) {
                    Text("Close")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .font(.headline)
                }
            }
            .navigationBarTitle("Invoice View", displayMode: .inline)
        }
    }

