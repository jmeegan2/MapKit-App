//
//  ComponentResultView.swift
//  MapKit_App
//
//  Created by James Meegan on 5/3/23.
//
import SwiftUI
import Foundation

struct ComponentResultView: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
        }
    }
}

