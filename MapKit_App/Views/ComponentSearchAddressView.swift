//
//  SearchAddressView.swift
//  MapKit_App
//
//  Created by James Meegan on 5/6/23.
//

import Foundation
import SwiftUI
struct ComponentSearchAddressView: View {
    @ObservedObject var viewModel: TripViewModel
    @FocusState private var isFocusedTextField: Bool
    @Binding var selectedAddress: String
    @Binding var isShowing: Bool
    var value = 4
    var body: some View {
        NavigationView {
            VStack {
               
                    List(viewModel.results) { address in
                        Button(action: {
                            selectedAddress = address.title
                            viewModel.searchableText = ""
                            viewModel.results = []
                            isFocusedTextField = false
                        }) {
                            ComponentAddressRow(address: address)
                                .listRowBackground(Color(.yellow))
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
       
            }
        }
    
}
