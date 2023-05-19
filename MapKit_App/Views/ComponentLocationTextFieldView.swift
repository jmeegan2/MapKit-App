//
//  LocationTextField.swift
//  MapKit_App
//
//  Created by James Meegan on 4/20/23.
//

import SwiftUI
import Foundation

struct ComponentLocationTextFieldView: View {
    var label: String
    @Binding var text: String
    @ObservedObject var viewModel: TripViewModel
    @FocusState private var isFocusedTextField: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            TextField(label, text: $text.onChange { newText in
                viewModel.searchableText = newText
            })
                .padding(.all, 7)
                .background(Color("TextField"))
                .cornerRadius(10)
                .autocapitalization(UITextAutocapitalizationType.words)
                .disableAutocorrection(true)
                .onReceive(
                    viewModel.$searchableText.debounce(
                        for: .seconds(1),
                        scheduler: DispatchQueue.main
                    )
                ) {
                    viewModel.searchAddress($0)
                }
            
                .focused($isFocusedTextField)
            
            if isFocusedTextField && !text.isEmpty {
                List(viewModel.results) { address in
                    Button(action: {
                        viewModel.requestAuthorisation()
                        text = String("\(address.title) \(address.subtitle)")
                        viewModel.checkAddressAndModifyLocationString(addressTitle: address.title)
                        viewModel.searchableText = ""
                        viewModel.results = []
                        isFocusedTextField = false
                    }) {
                        
                        AddressRow(address: address)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .frame(height:225)
            } 
        }
       
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}


