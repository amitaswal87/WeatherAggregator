//
//  WeatherAggregatorTestsDatabase.swift
//  WeatherAggregatorTests
//
//  Created by apple  on 24/09/24.
//

import XCTest
import CoreData
@testable import WeatherAggregator // Replace with your app's module



class WeatherAggregatorTestsDatabase : XCTestCase{
    
    var mockPersistentContainer = DatabaseService.shared.persistentContainer
    var weatherManager = WeatherStorageManager()

    override func setUp() {
        super.setUp()
        
        
    }
    override func tearDown() {
        super.tearDown()
    }
    
    func testSaveWeather_AddsNewWeatherData() {
        // Given: Create a sample WeatherModel array
        let weatherModel = WeatherModel(location: Location(name: "New York", country: "USA"),
                                        current: Current(temp_c: 22.5))
        
        let weatherArray = [weatherModel]
        
        // When: Call saveWeather
        let expectation = XCTestExpectation(description: "Save new weather data")
        weatherManager.saveWeather(weather: weatherArray)
        
        // Simulate async operation to allow the background context to save
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            // Then: Fetch the WeatherEntity and check if it's saved correctly
            let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "cityName == %@", "New York")
            
            do {
                let results = try self.mockPersistentContainer.viewContext.fetch(fetchRequest)
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results.first?.cityName, "New York")
                XCTAssertEqual(results.first?.temprature, 22.5)
                XCTAssertEqual(results.first?.country, "USA")
            } catch {
                XCTFail("Failed to fetch WeatherEntity: \(error)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
        
        weatherManager.deleteWeather(name: "New York")
    }
       
}
