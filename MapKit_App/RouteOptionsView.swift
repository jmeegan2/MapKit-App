//
//  RouteOptionsView.swift
//  MapKit_App
//
//  Created by James Meegan on 4/20/23.
//
import SwiftUI
import Foundation

struct TogglesView: View {
    @Binding var avoidTolls: Bool
    @Binding var avoidHighways: Bool

    var body: some View {
        HStack {
            Toggle("Avoid Tolls", isOn: $avoidTolls)
                .padding(.vertical, 2)
                .fontWeight(.bold)
            Spacer()
            Toggle("Avoid Highways", isOn: $avoidHighways)
                .padding(.vertical, 2)
                .fontWeight(.bold)
        }
    }
}
