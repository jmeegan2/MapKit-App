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
        XCTAssertEqual(sut.distanceDecimalOne, 0)
        XCTAssertEqual(sut.cost, 0)
        XCTAssertFalse(sut.avoidTolls)
        XCTAssertFalse(sut.avoidHighways)
        XCTAssertEqual(sut.time, 0)
        XCTAssertFalse(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "")
        XCTAssertFalse(sut.calculateButtonPressed)
        XCTAssertFalse(sut.showInfoAlert)
    }

    func testCalculateTripDetails() {
        sut.calculateTripDetails()
        XCTAssertTrue(sut.calculateButtonPressed)
        XCTAssertNotNil(sut.mapIdentifier)
    }
}
