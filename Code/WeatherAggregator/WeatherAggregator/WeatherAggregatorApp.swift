//
//  WeatherAggregatorApp.swift
//  WeatherAggregator
//
//  Created by apple  on 24/09/24.
//

import SwiftUI

@main
struct WeatherAggregatorApp: App {
    var body: some Scene {
        WindowGroup {
            // Initialize the network service
            let networkService = NetworkService(apiService: APIService(), parsingService: ParsingService())
            let weatherStorageManager = WeatherStorageManager()
            // Initialize the view model
            let viewModel = WeatherViewModel(networkService: networkService, weatherStorageManager: weatherStorageManager)

            ContentView(viewModel: viewModel)
        }
    }
}
