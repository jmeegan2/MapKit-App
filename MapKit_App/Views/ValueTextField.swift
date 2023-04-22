//
//  ValueTextField.swift
//  MapKit_App
//
//  Created by James Meegan on 4/20/23.
//
import SwiftUI
import Foundation


struct ValueTextField: View {
    var label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            TextField(label, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}