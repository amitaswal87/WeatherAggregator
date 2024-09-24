//
//  MockNetworkService.swift
//  WeatherAggregator
//
//  Created by apple  on 24/09/24.
//

import Foundation

class MockNetworkService : NetworkServiceDelegate{
    
    var data: Data?
    var error: Error?
    
    func fetchRequest<T>(type: T.Type, url: URL, completion: @escaping (((Result<T, APIError>))) -> Void) where T : Decodable {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            do{
                let parsedData = try JSONDecoder().decode(type, from: self.data!)
                completion(.success(parsedData))
            }catch{
                completion(.failure(APIError.noData))
            }
            
        }
    }
    

    
}
