//
//  ValueTextField.swift
//  MapKit_App
//
//  Created by James Meegan on 4/20/23.
//
import SwiftUI
import Foundation

struct ComponentValueTextFieldView: View {
    
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
                            .foregroundColor(Color("Button"))
                    }
                   }
                
            }
            TextField(label, text: $text)
                .padding(.all, 7)
                .background(Color("TextField"))
                .cornerRadius(10)

        }
        .popover(isPresented: $tapped) {
            VStack {
                Spacer()
                Text("Info")
                    .font(.system(size: 25, weight:.bold, design: .default))
                    .padding(.bottom, 8)
                    .foregroundColor(Color(("Button")))
                Text("Please provide the current price of fuel in the United States, indicating either the local price in your area or the national average price per gallon.")
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                    
                Spacer()
            }
            .frame(maxWidth:375)
            .padding()
        }
    }
}
