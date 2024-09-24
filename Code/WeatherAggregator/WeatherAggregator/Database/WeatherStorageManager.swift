//
//  WeatherStorageManager.swift
//  WeatherUpdate
//
//  Created by apple  on 21/09/24.
//

import Foundation
import CoreData

class WeatherStorageManager : StorageManagerDelegate,WeatherStorageManagerDelegate{
    
    // saving the data fetched
    func saveWeather(weather: [WeatherModel]) {
        self.persistentContainer.performBackgroundTask { backgroundContext in
            for weatherData in weather {
                
                let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "\(kWeatherCityName) == %@", weatherData.location?.name ?? "")
                do {
                    // update the data is already stored in database
                    let results = try backgroundContext.fetch(fetchRequest)
                    if let weatherEntity = results.first {
                        // Update existing entity
                        weatherEntity.temprature = weatherData.current?.temp_c ?? 0.0
                    } else {
                        // Add new entity if already doesnot exists in database
                        let record = WeatherEntity(context: backgroundContext)
                        record.cityName = weatherData.location?.name
                        record.temprature = weatherData.current?.temp_c ?? 0.0
                        record.country = weatherData.location?.country
                    }
                }catch {
                    print("Error fetching WeatherEntity: \(error)")
                }
            }
            
            // Save the context to persist data
            do {
                try backgroundContext.save()
//                print("Data saved successfully.")
            } catch {
                print("Failed to save data: \(error.localizedDescription)")
            }

        }
    }
    
    func fetchWeather() -> [WeatherEntity]? {
        // Get the Core Data context
        let context = self.mainContext
        let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        do {
            let record = try context.fetch(fetchRequest)
            return record
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Function to delete an item based on its id
        func deleteWeather(name : String) {
            // Create a fetch request for the entity you want to delete
            let fetchRequest: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
            
            // Specify the criteria to find the item (e.g., the item's id)
            fetchRequest.predicate = NSPredicate(format: "cityName == %@", name as CVarArg)
            
            do {
                // Fetch the objects that match the criteria
                let items = try self.persistentContainer.viewContext.fetch(fetchRequest)
                
                // Check if the object exists and then delete it
                if let itemToDelete = items.first {
                    self.persistentContainer.viewContext.delete(itemToDelete)
                    // Save the context to persist the changes
                    try self.persistentContainer.viewContext.save()
                    
                    print("Item with ID \(name) deleted successfully.")
                } else {
                    print("Item not found.")
                }
            } catch let error as NSError {
                print("Could not delete item. \(error), \(error.userInfo)")
            }
        }
}
extension WeatherEntity {
    // convert entity model to swift model
    func toWeatherModel() -> WeatherModel {
        let model = WeatherModel(location: Location(name: self.cityName, country: self.country), current: Current(temp_c: self.temprature))
        return model
    }
}
