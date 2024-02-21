//
//  Places.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/20.
//

import Foundation

// MARK: - Geometry
struct Geometry: Decodable {
    let location: Location
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double
}

struct PlaceResponseModel: Decodable {
    let results: [Result]
    
    struct Result: Decodable {
        let place_id: String?
        let name: String?
    }
}

struct PlaceDetailsModel: Decodable {
    let result: Result
    
    struct Result: Decodable {
        let photos: [Photo]?
        let name: String?
        let formatted_address: String?
        let geometry: Geometry
    }
    
    struct Photo: Decodable {
        let height: Int
        let width: Int
        let photo_reference: String
    }
}
