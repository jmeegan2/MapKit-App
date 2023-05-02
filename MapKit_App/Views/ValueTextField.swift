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
    @State var showInfoIcon: Bool = false
    @State var tapped: Bool = false

//    @Binding var iconTapped: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                    .font(.headline)
                if showInfoIcon {
                       Image(systemName: "info.circle")
                           .foregroundColor(.blue)
                   }
                
            }
            TextField("", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
