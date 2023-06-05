//
//  OpenInAppleMapsButton.swift
//  MapKit_App
//
//  Created by James Meegan on 4/20/23.
//

import SwiftUI
import Foundation

struct ComponentAppleMapsButtonView: View {
    var action: () -> Void
    

    var body: some View {
        Button(action: action) {
            Text("Open in Apple Maps")
                .foregroundColor(Color("ButtonText"))
                .background(Color("Button"))
                .frame(maxWidth: .infinity)
                .padding(.all, 10.0)
                .foregroundColor(.white)
                .background(Color("Button"))
                .fontWeight(.bold)
                .cornerRadius(10)
        }
    }
}
