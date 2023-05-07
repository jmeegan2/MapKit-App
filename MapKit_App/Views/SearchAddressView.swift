//
//  SearchAddressView.swift
//  MapKit_App
//
//  Created by James Meegan on 5/6/23.
//

import Foundation
import SwiftUI
struct SearchAddressView: View {
    @ObservedObject var viewModel: TripViewModel
    @FocusState private var isFocusedTextField: Bool
    @Binding var selectedAddress: String
    @Binding var isShowing: Bool
    var body: some View {
        NavigationView {
            VStack {
                TextField("Type address", text: $viewModel.searchableText)
                    .padding()
                    .autocorrectionDisabled()
                    .focused($isFocusedTextField)
                    .font(.title)
                    .onReceive(
                        viewModel.$searchableText.debounce(
                            for: .seconds(1),
                            scheduler: DispatchQueue.main
                        )
                    ) {
                        viewModel.searchAddress($0)
                    }
                    .background(Color.init(uiColor: .systemBackground))
                    .overlay {
                        ClearButton(text: $viewModel.searchableText)
                            .padding(.trailing)
                            .padding(.top, 8)
                    }
                    .onAppear {
                        isFocusedTextField = true
                    }

                List(viewModel.results) { address in
                           Button(action: {
                               selectedAddress = address.title
                               viewModel.searchableText = ""
                               viewModel.results = []
                               isFocusedTextField = false
                           }) {
                               AddressRow(address: address)
                                   .listRowBackground(Color(.yellow))
                           }
                }
                    .scrollContentBackground(.hidden)
            }
        }
    }
}
