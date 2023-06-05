//
//  InvoiceViewModel.swift
//  MapKit_App
//
//  Created by James Meegan on 6/4/23.
//

import Foundation
import SwiftUI
import Foundation


class InvoiceViewModel: ObservableObject {
    @Published var formattedDate = ""
    
    func date() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        formattedDate = dateFormatter.string(from: date)
    }
    
}
