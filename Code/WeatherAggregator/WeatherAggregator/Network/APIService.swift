//
//  APIService.swift
//  VC_VM_Interaction
//
//  Created by apple  on 03/07/24.
//

import Foundation


class APIService : APIServiceDelegate{
    

    func fetchData(url : URL , completion : @escaping (Result<Data,APIError>)->Void){
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
               return completion(.failure(.networkError))
            }
            if let finslResponse = response as? HTTPURLResponse, finslResponse.statusCode != 200{
                return completion(.failure(.wrongResponse))
            }
            
            guard let finalData = data else {
                return completion(.failure(.noData))
        }
            
            completion(.success(finalData))
        }.resume()
    }
    
    init() {
        
    }
}
