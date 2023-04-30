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
    
    @State private var showInfoPopover = false
    @State private var popoverRect: CGRect = .zero
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                    .font(.headline)
                if showInfoIcon {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            showInfoPopover.toggle()
                        }
                        .popover(isPresented: $showInfoPopover) {
                            VStack {
                                Text(infoMessage ?? "AAA National Average")
                                    .padding()
                            }
                        }
                }
            }
            TextField("", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
       
    }
}
