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
    @State var tapped = false

//    @Binding var iconTapped: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                    .font(.headline)
                if showInfoIcon {
                    Button( action: { tapped.toggle()}) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                            
                    }
                   }
                
            }
            TextField("", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.trailing)
        .popover(isPresented: $tapped) {
            VStack {
                Spacer()
                Text("Info")
                    .font(.system(size: 25, weight:.bold, design: .default))
                    .padding(.bottom, 8)
                    
                    .foregroundColor(.blue)
                Text("Today's US National Average for gasoline. \nSource: AAA (https://gasprices.aaa.com/)")
                    .padding(.horizontal)
                Spacer()
            }
            .frame(maxWidth:375)
            .padding()
        }
    }
}
