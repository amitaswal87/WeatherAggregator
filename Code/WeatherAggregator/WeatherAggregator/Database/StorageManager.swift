//
//  StorageManager.swift
//  WeatherUpdate
//
//  Created by apple  on 21/09/24.
//

import Foundation
import UIKit
import CoreData


protocol StorageManagerDelegate {
    var mainContext: NSManagedObjectContext { get }
    var persistentContainer: NSPersistentContainer { get }
    var backgroundContext: NSManagedObjectContext { get }
}
extension StorageManagerDelegate {
    
    // Default implementation for `persistentContainer`
    var persistentContainer: NSPersistentContainer {
        return DatabaseService.shared.persistentContainer
    }
    // Default implementation for `mainContext` using the persistent container
    var mainContext: NSManagedObjectContext {
        return DatabaseService.shared.persistentContainer.viewContext
    }
    // Default implementation for `background Context` using the persistent container
    var backgroundContext: NSManagedObjectContext {
        return DatabaseService.shared.persistentContainer.newBackgroundContext()
    }
}
