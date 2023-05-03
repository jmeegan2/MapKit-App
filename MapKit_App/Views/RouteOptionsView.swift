//
//  RouteOptionsView.swift
//  MapKit_App
//
//  Created by James Meegan on 4/20/23.
//

import SwiftUI
import Foundation

struct RouteOptionsView: View {
    @Binding var avoidTolls: Bool
    @Binding var avoidHighways: Bool
    @State private var showingPopover = false
    @State private var buttonRect: CGRect = .zero
    
    var body: some View {
        VStack {
            Button(action: {
                showingPopover.toggle()
            }) {
                HStack {
                    Text("Route Options")
                        .font(.headline)
                    Image(systemName: "gearshape")
                }
            }
        }
        .popover(isPresented: $showingPopover) {
            popoverContent
        }
    }
    
    private var popoverContent: some View {
        VStack {
            Spacer()
            Text("Route Options")
                .font(.system(size: 25, weight:.bold, design: .default))
                .padding(.bottom, 8)
                .foregroundColor(.blue)
           
            VStack(spacing: 16) {
                Toggle(isOn: $avoidTolls) {
                    Text("Avoid Tolls")
                        .font(.body)
                }
                Toggle(isOn: $avoidHighways) {
                    Text("Avoid Highways")
                        .font(.body)
                }
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding()
    }
}
