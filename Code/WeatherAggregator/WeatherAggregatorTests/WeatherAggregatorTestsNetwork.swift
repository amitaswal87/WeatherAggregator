//
//  WeatherAggregatorTestsNetwork.swift
//  WeatherAggregatorTests
//
//  Created by apple  on 24/09/24.
//

import XCTest
@testable import WeatherAggregator


final class WeatherAggregatorTestsNetwork: XCTestCase {


    var mockNetworkService: MockNetworkService!

    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        try super.setUpWithError()
        // Initialize the view model

        
        mockNetworkService = MockNetworkService()

        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

        mockNetworkService = nil

        try super.tearDownWithError()

    }
    
    //MARK:- Test API
    func testGetWeather_Success() {
        // Given: Mock data for a successful response
        let json = """
        {
          "location": {
            "name": "New York"
          },
          "current": {
            "temp_c": 22.5
          }
        }
        """.data(using: .utf8)!
        var mockData : WeatherModel
        do{
            mockData = try JSONDecoder().decode(WeatherModel.self, from: json)
        }catch{
            mockData = WeatherModel(location: Location(name: "",country: ""), current: Current(temp_c: 0.0))
        }
        mockNetworkService.data = json
        mockNetworkService.error = nil
        
        let expectation = XCTestExpectation(description: "Weather fetch")
        
        // When: Fetch weather
        mockNetworkService.fetchRequest(type: WeatherModel.self, url: URL(string: kBerlinWeatherURL)!) { result in
            switch result{
            case .success(let data):
                // validate data
                print(data)
                XCTAssertEqual(data, mockData)
            case .failure(let error):
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

}
