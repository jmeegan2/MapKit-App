//
//  SendInvoiceView.swift
//  MapKit_App
//
//  Created by James Meegan on 5/23/23.
//

import Foundation
import SwiftUI

struct HiPage: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TripViewModel

    var body: some View {
        VStack {
            //viewModel.starting location to viewModel.destination
            //viewModel.distance
            Spacer()

            Button(action: {
                presentationMode.wrappedValue.dismiss() // Close the screen
            }) {
                Text("Close")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
   

}
