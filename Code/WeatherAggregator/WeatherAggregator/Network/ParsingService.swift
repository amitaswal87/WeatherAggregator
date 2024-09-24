//
//  ParsingService.swift
//  VC_VM_Interaction
//
//  Created by apple  on 03/07/24.
//

import Foundation



class ParsingService :ParsingServiceDelegate{
    
    func parseData<T:Decodable>(data : Data, type : T.Type, completion :@escaping (Result<T,APIError>)-> Void){
        do {
            let parsedData = try JSONDecoder().decode(type, from: data)
            completion(.success(parsedData))
        }catch{
            completion(.failure(.parsingError))
        }
    }

    init() {
        
    }
}
