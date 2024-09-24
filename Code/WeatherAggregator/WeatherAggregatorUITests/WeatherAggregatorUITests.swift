//
//  WeatherAggregatorUITests.swift
//  WeatherAggregatorUITests
//
//  Created by apple  on 24/09/24.
//

import XCTest
@testable import WeatherAggregator

final class WeatherAggregatorUITests: XCTestCase {


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

      

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

    }

    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
