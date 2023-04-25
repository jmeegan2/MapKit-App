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
    @State private var showingPopover = false
    var body: some View {
            Button(action: {
                showingPopover = true
            }) {
                HStack {
                    Text("Route Options")
                        .font(.headline)
                    Image(systemName: "gearshape")
                }
            }
            .popover(isPresented: $showingPopover) {
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
                    
                    Spacer()
                }
                .padding()
            }
        }
    
  }
