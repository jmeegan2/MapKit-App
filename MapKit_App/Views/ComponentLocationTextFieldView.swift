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
                print(text.count)
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
                        text = address.title
                        viewModel.searchableText = ""
                        viewModel.results = []
                        isFocusedTextField = false
                    }) {
                        
                        AddressRow(address: address)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .frame(height:200)
            } else if text.isEmpty {
                
            }
        } .onAppear{
            viewModel.requestAuthorisation()
            print(viewModel.requestAuthorisation())
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
