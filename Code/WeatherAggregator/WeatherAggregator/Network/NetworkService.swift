//
//  NetworkService.swift
//  VC_VM_Interaction
//
//  Created by apple  on 03/07/24.
//

import Foundation



class NetworkService : NetworkServiceDelegate{    
    
    init(apiService: APIServiceDelegate, parsingService: ParsingServiceDelegate) {
        self.apiService = apiService
        self.parsingService = parsingService
    }

    private let apiService : APIServiceDelegate
    private let parsingService : ParsingServiceDelegate
    
    // fetch data from server
    func fetchRequest<T : Decodable>(type: T.Type, url: URL, completion: @escaping ((Result<T, APIError>) -> Void)){
        
        self.apiService.fetchData(url: url) { result in
            switch result{
            case .success(let data):
                // decode fetched data
                self.parsingService.parseData(data: data, type: type.self) { response in
                    switch response{
                    case .success(let parsedData):
                        completion(.success(parsedData))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    
}
