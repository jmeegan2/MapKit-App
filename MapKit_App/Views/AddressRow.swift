//
//  AddressRow.swift
//  MapKit_App
//
//  Created by James Meegan on 5/6/23.
//

import Foundation
import SwiftUI

struct AddressRow: View {
    
    let address: AddressResult
    
    var body: some View {
        NavigationLink {
//            MapView(address: address)
        } label: {
            VStack(alignment: .leading) {
                Text(address.title)
                Text(address.subtitle)
                    .font(.caption)
            }
        }
        .padding(.bottom, 2)
    }
}
