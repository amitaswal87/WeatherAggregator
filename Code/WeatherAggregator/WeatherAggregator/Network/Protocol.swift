//
//  Protocol.swift
//  VC_VM_Interaction
//
//  Created by apple  on 03/07/24.
//

import Foundation


protocol WeatherStorageManagerDelegate{
    func fetchWeather() -> [WeatherEntity]?
    func saveWeather(weather: [WeatherModel]) 
}

protocol NetworkServiceDelegate{
    func fetchRequest<T:Decodable>(type : T.Type, url : URL, completion :@escaping (((Result<T,APIError>)))->Void)
}

protocol APIServiceDelegate{
    func fetchData(url : URL , completion : @escaping(Result<Data,APIError>)->Void)
}

protocol ParsingServiceDelegate{
    func parseData<T:Decodable>(data : Data, type : T.Type, completion :@escaping (Result<T,APIError>)-> Void)
}

