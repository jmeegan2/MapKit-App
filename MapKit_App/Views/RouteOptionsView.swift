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
            HStack {
                Button(action: {
                    showingPopover = false
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Back")
                            .font(.headline)
                    }
                    .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding(.horizontal)

            Divider()

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
            
        }
        .padding()
    }
    
}
