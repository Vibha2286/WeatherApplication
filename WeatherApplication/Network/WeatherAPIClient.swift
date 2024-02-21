//
//  WeatherAPIClient.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/18.
//

import Foundation

public enum WeatherState {
    case cloudy
    case rainy
    case sunny
}

enum SuffixURL: String {
    case forecastWeather = "forecast"
    case currentWeather = "weather"
}

struct WeatherAPIClient {
    
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, Error?) -> Void
    typealias ForecastWeatherCompletionHandler = (ForecastWeatherResponse?, Error?) -> Void
    
    private let apiKey = "b3e8da6dc891d50580ecc4c39eecb744"
    
    private func baseUrl(_ suffixURL: SuffixURL, lat: Double, long: Double) -> URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/\(suffixURL.rawValue)?lat=\(lat)&lon=\(long)&appid=\(self.apiKey)")!
    }
    
    func fetchCurrentWeatherDetails(lat: Double, long: Double, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
        let url = baseUrl(SuffixURL.currentWeather, lat: lat, long: long)
        Endpoint().getBaseRequest(url: url) { (weather: CurrentWeather?, error) in
            completion(weather, error)
        }
    }
    
    func fetchWeatherForecast(lat: Double, long: Double, completionHandler completion: @escaping ForecastWeatherCompletionHandler) {
        let url = baseUrl(SuffixURL.forecastWeather, lat: lat, long: long)
        Endpoint().getBaseRequest(url: url) { (weather: ForecastWeatherResponse?, error) in
            completion(weather, error)
        }
    }
}
