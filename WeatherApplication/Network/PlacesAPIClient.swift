//
//  PlacesAPIClient.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/20.
//

import Foundation

enum PlacesAPIConstants {
    
    static let baseURL = "https://maps.googleapis.com/maps/api/place"
    static let apiKey = "AIzaSyDT08Q1TUdrMQRRRcdyzkn8idQ0YxEBUIo"
}

public enum SuffixPlacesAPIURL: String {
    case locationTextsearch = "/textsearch/json"
    case locationDetails = "/details/json"
}

struct PlacesAPIClient {
    
    typealias PlaceNameCompletionHandler = (PlaceResponseModel?, Error?) -> Void
    typealias PlaceDetailsCompletionHandler = (PlaceDetailsModel?, Error?) -> Void
        
    private func placeUrlRequest(_ suffixURL: SuffixPlacesAPIURL, text: String) -> URL {
        return URL(string: "\(PlacesAPIConstants.baseURL)\(suffixURL.rawValue)?query=\(text)&key=\(PlacesAPIConstants.apiKey)")!
    }
    
    private func placeDetailsUrlRequest(_ suffixURL: SuffixPlacesAPIURL, placeID: String) -> URL {
        return URL(string: "\(PlacesAPIConstants.baseURL)\(suffixURL.rawValue)?place_id=\(placeID)&key=\(PlacesAPIConstants.apiKey)")!
    }
    
    func fetchPlace(name: String, completion: @escaping PlaceNameCompletionHandler) {
        let url = placeUrlRequest(SuffixPlacesAPIURL.locationTextsearch, text: name)
        Endpoint().getBaseRequest(url: url) { (response: PlaceResponseModel?, error) in
            completion(response, error)
        }
    }
    
    func fetchPlaceDetails(placeID: String, completion: @escaping PlaceDetailsCompletionHandler) {
        let url = placeDetailsUrlRequest(SuffixPlacesAPIURL.locationDetails, placeID: placeID)
        Endpoint().getBaseRequest(url: url) { (response: PlaceDetailsModel?, error) in
            completion(response, error)
        }
    }
}
