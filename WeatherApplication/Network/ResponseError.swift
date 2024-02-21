//
//  ResponseError.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/18.
//

import Foundation

enum ResponseError: Error {
    
    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
    case invalidURL
}
