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
    @Published  var isSplittingCost = false
    @Published var perPersonCostSection = false
    @Published var calculateCostString = ""
    @Published var sendInvoiceCostPerPerson = ""
    @Published var sendInvoiceNumberOfPeople = ""
    

    
    init() {
       date()
    }
    func date() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        formattedDate = dateFormatter.string(from: date)
    }
    
    func calculateCost(costValue: Double, numberOfPeopleValue: Double?) {
            if let numberOfPeople = numberOfPeopleValue, costValue > 0, numberOfPeople > 0 {
                let calculatedCost = costValue / numberOfPeople
                calculateCostString = String(format: "%.2f", calculatedCost)
                perPersonCostSection = true
                sendInvoiceCostPerPerson = "Cost Per Person: $\(calculateCostString)"
                sendInvoiceNumberOfPeople = "Number of People: \(numberOfPeople)"
            } else {
                perPersonCostSection = false
            }
        }
    
}
