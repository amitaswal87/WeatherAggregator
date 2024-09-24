//
//  CustomError.swift
//  WeatherAggregator
//
//  Created by apple  on 23/09/24.
//


enum APIError : Error{
    case networkError
    case noData
    case wrongResponse
    case parsingError
    case invalidURL
}
