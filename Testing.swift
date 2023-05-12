//
//  Testing.swift
//  MapKit_App
//
//  Created by James Meegan on 5/11/23.
//

import XCTest

final class TripViewModelTests: XCTestCase {

    var app: MapKit_App = MapKit_App()
    var viewModel: TripViewModel!

    override func setUpWithError() throws {
        viewModel = TripViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testInitialValues() throws {
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.startingLocation, "")
        XCTAssertEqual(viewModel.destinationLocation, "")
        XCTAssertEqual(viewModel.mpg, "")
        XCTAssertEqual(viewModel.averageGasPrice, "")
        XCTAssertEqual(viewModel.distance, 0)
        XCTAssertEqual(viewModel.distanceDecimalOne, 0)
        XCTAssertEqual(viewModel.cost, 0)
        XCTAssertFalse(viewModel.avoidTolls)
        XCTAssertFalse(viewModel.avoidHighways)
        XCTAssertEqual(viewModel.time, 0)
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertEqual(viewModel.alertMessage, "")
        XCTAssertFalse(viewModel.calculateButtonPressed)
        XCTAssertFalse(viewModel.showInfoAlert)
    }

    func testTimeFormatting() throws {
        XCTAssertEqual(viewModel.formatTime(25), "1 day 1 hour")
        XCTAssertEqual(viewModel.formatTime(0.5), "30 minutes")
        XCTAssertEqual(viewModel.formatTime(1.5), "1 hour 30 minutes")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            viewModel.searchAddress("New York")
        }
    }
}

