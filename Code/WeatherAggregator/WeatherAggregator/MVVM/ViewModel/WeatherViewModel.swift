//
//  WeatherViewModel.swift
//  WeatherUpdate
//
//  Created by apple  on 20/09/24.
//

import Foundation



class WeatherViewModel : ObservableObject{
    

    var apiData : [WeatherModel] = []
    @Published var filteredApiData: [WeatherModel] = [] // Filtered data for search

    private let networkService: NetworkServiceDelegate
    private let weatherStorageManager : WeatherStorageManagerDelegate

    private let dispatchGroup = DispatchGroup()
    private let concurrentQueue = DispatchQueue(label: kWeatherAPIQueuelabel, attributes: .concurrent)
    private let responseLock = NSLock() // To ensure thread-safety when accessing the array
    
    //MARK: init
    // Dependency Injection via initializer + dependency inversion
    init(networkService: NetworkServiceDelegate , weatherStorageManager : WeatherStorageManagerDelegate) {
        self.networkService = networkService
        self.weatherStorageManager = weatherStorageManager
    }
    
    // MARK: - Business
    func fetchRequest(){
        // Save models from database
        self.fetchFromDatabase {
            // if data already available in database
            if self.apiData.count > 0{
                // reload with available database data
                self.filteredApiData = self.apiData
            }
            else{
                // fetch from api and save in database
                self.fetchFromAPI()
            }
        }
    }
    func fetchFromDatabase(completion : @escaping ()-> Void){
        self.apiData.removeAll()
        if let savedWeather =  self.weatherStorageManager.fetchWeather() {
            for weather in savedWeather {
                self.responseLock.lock()
                self.apiData.append(weather.toWeatherModel())
                self.responseLock.unlock()
                print("Name: \(weather.cityName ?? ""), ID: \(weather.temprature)")
            }
        }
        completion()
    }
    func fetchFromAPI(){
        //TODO: Lock missing. TBD
        self.apiData.removeAll()
        let finalURLArray = [URL(string: kBerlinWeatherURL),
                             URL(string: kLondonWeatherURL),
                             URL(string: kTokyoWeatherURL),
                             URL(string: kSydneyWeatherURL),
                             URL(string: kMumbaiWeatherURL)]
        
        for url in finalURLArray{
            guard let finalUrl = url else{
                return
            }
            dispatchGroup.enter()
            concurrentQueue.async {
                self.networkService.fetchRequest(type: WeatherModel.self, url: finalUrl) { [weak self]result in
                    switch result {
                    case .success(let parsedData):
                        self?.responseLock.lock()
                        self?.apiData.append(parsedData)
                        self?.responseLock.unlock()
                    case .failure(let error):
                        print(error)
                    }
                    self?.dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.saveDataToDatabase()
            self.filteredApiData = self.apiData

        }
    }
    
    func saveDataToDatabase(){
        DispatchQueue.global().async{
            self.weatherStorageManager.saveWeather(weather: self.apiData)
        }
    }
}

// MARK: - Filter Logic
extension WeatherViewModel{
    func nameSort(){
        if self.filteredApiData.count <= 0 {
            return
        }
        // Sorting the array by the name of the location
        let sortedWeatherModels = self.filteredApiData.sorted {
            guard let name1 = $0.location?.name, let name2 = $1.location?.name else {
                return false // Handle cases where names might be nil
            }
            return name1 < name2
        }
        self.filteredApiData = sortedWeatherModels
    }
    func tempratureSort(){
        if self.filteredApiData.count <= 0 {
            return
        }
        // Sorting the array by temp_c in ascending order
        let sortedWeatherModelsByTemp = self.filteredApiData.sorted {
            guard let temp1 = $0.current?.temp_c, let temp2 = $1.current?.temp_c else {
                return false // Handle cases where temp_c might be nil
            }
            return temp1 < temp2
        }
        self.filteredApiData = sortedWeatherModelsByTemp
    }
    
    func filterDataWithText(text:String){
        if text.isEmpty {
            self.filteredApiData = self.apiData  // Show all data if search text is empty
        } else {
            self.filteredApiData = self.apiData.filter { weather in
                return weather.location?.name?.lowercased().contains(text.lowercased()) ?? false
            }
        }
    }

}
