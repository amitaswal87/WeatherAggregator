//
//  Models.swift
//  VC_VM_Interaction
//
//  Created by apple  on 03/07/24.
//

import Foundation


// MARK: - WeatherModel
struct WeatherModel: Codable,Equatable {
    static func == (lhs: WeatherModel, rhs: WeatherModel) -> Bool {
        return lhs.location == rhs.location && lhs.current == rhs.current
    }
    
    let location: Location?
    let current: Current?
}

// MARK: - Current
struct Current: Codable, Equatable {
    let temp_c : Double?
}

// MARK: - Location
struct Location: Codable ,Equatable{
    let name: String?
    let country:String?
}



