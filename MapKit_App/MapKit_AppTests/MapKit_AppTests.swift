//
//  MapKit_AppTests.swift
//  MapKit_AppTests
//
//  Created by James Meegan on 5/17/23.
//

@testable import MapKit_App
import XCTest
import CoreLocation
import MapKit

final class TripViewModelTests: XCTestCase {
    
    var sut: TripViewModel!
    
    override func setUpWithError() throws {
        sut = TripViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testInitialValues() throws {
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.startingLocation, "")
        XCTAssertEqual(sut.destinationLocation, "")
        XCTAssertEqual(sut.mpg, "")
        XCTAssertEqual(sut.averageGasPrice, "")
        XCTAssertEqual(sut.distance, 0)
        XCTAssertEqual(sut.cost, "")
        XCTAssertFalse(sut.avoidTolls)
        XCTAssertFalse(sut.avoidHighways)
        XCTAssertFalse(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "")
        XCTAssertFalse(sut.calculateButtonPressed)
        XCTAssertFalse(sut.showInfoAlert)
    }
    
    func testCalculateTripDetails() {
        sut.startingLocation = "New York"
        sut.destinationLocation = "Los Angeles"
        sut.mpg = "25"
        sut.averageGasPrice = "3.5"
        
        let route = MKRoute() // Create a mock MKRoute object with the desired values
        
        sut.updateTripDetails(from: route, mpg: 25, gasPrice: 3.5)
        
        // Assert the expected values based on the updateTripDetails method
        
        XCTAssertFalse(sut.cost.isEmpty)
        XCTAssertFalse(sut.stringDistance.isEmpty)
    }
}
