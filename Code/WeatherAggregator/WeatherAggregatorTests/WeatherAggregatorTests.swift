//
//  WeatherAggregatorTests.swift
//  WeatherAggregatorTests
//
//  Created by apple  on 24/09/24.
//

import XCTest
@testable import WeatherAggregator

final class WeatherAggregatorTests: XCTestCase {

    var viewModel: WeatherViewModel!  // Replace with your ViewModel type
    let networkService = NetworkService(apiService: APIService(), parsingService: ParsingService())
    let weatherStorageManager = WeatherStorageManager()

    var mockNetworkService: MockNetworkService!

    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        try super.setUpWithError()
        // Initialize the view model
        let vm = WeatherViewModel(networkService: networkService, weatherStorageManager: weatherStorageManager)
        viewModel = vm
        
        mockNetworkService = MockNetworkService()

        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockNetworkService = nil

        try super.tearDownWithError()

    }

    //MARK: - Test Name Sorting
    func testSort_name() {
        // Given: Mock data with varying location names
        let weather1 = WeatherModel(location: Location(name: "Paris",country: ""), current: Current(temp_c: 25.0))
        let weather2 = WeatherModel(location: Location(name: "Berlin",country: ""), current: Current(temp_c: 20.0))
        let weather3 = WeatherModel(location: Location(name: "Amsterdam",country: ""), current: Current(temp_c: 15.0))
        
        viewModel.filteredApiData = [weather1,weather2,weather3]
        
        // When: Perform the name sort
        viewModel.nameSort()
        
        // Then: Check if the data is correctly sorted by location names
        XCTAssertEqual(viewModel.filteredApiData[0].location?.name, "Amsterdam")
        XCTAssertEqual(viewModel.filteredApiData[1].location?.name, "Berlin")
        XCTAssertEqual(viewModel.filteredApiData[2].location?.name, "Paris")
    }
    
    func testNameSort_EmptyData() {
        // Given: Empty data
        viewModel.filteredApiData = []
        
        // When: Perform the name sort
        viewModel.nameSort()

        // Then: Ensure the data remains empty
        XCTAssertEqual(viewModel.filteredApiData.count, 0)
    }
    
    //MARK:- Test temprature sorting
    func testSort_temprature() {
        // Given: Mock data with varying location names
        let weather1 = WeatherModel(location: Location(name: "Paris",country: ""), current: Current(temp_c: 125.0))
        let weather2 = WeatherModel(location: Location(name: "Berlin",country: ""), current: Current(temp_c: 20.0))
        let weather3 = WeatherModel(location: Location(name: "Amsterdam",country: ""), current: Current(temp_c: 225.0))

        viewModel.filteredApiData = [weather1,weather2,weather3]
        
        // When: Perform the name sort
        viewModel.tempratureSort()
        
        // Then: Check if the data is correctly sorted by location names
        XCTAssertEqual(viewModel.filteredApiData[0].current?.temp_c, 20.0)
        XCTAssertEqual(viewModel.filteredApiData[1].current?.temp_c, 125.0)
        XCTAssertEqual(viewModel.filteredApiData[2].current?.temp_c, 225.0)
    }
    
    
    func testTempratureSort_EmptyData() {
        // Given: Empty data
        viewModel.filteredApiData = []
        
        // When: Perform the name sort
        viewModel.tempratureSort()
        
        // Then: Ensure the data remains empty
        XCTAssertEqual(viewModel.filteredApiData.count, 0)
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
