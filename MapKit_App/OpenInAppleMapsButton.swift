//
//  OpenInAppleMapsButton.swift
//  MapKit_App
//
//  Created by James Meegan on 4/20/23.
//

import SwiftUI
import Foundation

struct OpenInAppleMapsButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Open in Apple Maps")
                .frame(maxWidth: .infinity)
                .padding(.all, 10.0)
                .foregroundColor(.white)
                .background(Color(red: 30/255, green: 65/255, blue: 105/255))
                .fontWeight(.bold)
                .cornerRadius(10)
        }
    }
}
