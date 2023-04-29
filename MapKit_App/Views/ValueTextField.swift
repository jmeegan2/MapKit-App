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
    var showInfoIcon: Bool = false
    var infoMessage: String?
    
    @State private var showInfoAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                    .font(.headline)
                Spacer()
                if showInfoIcon {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            print("hello")
                            showInfoAlert = true
                            if(showInfoAlert){
                                print("show info change")
                            }
                        }
                }
            }
            TextField("", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
       
    }
    
}
