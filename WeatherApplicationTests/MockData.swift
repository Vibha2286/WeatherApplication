//
//  MockData.swift
//  WeatherApplicationTests
//
//  Created by Vibha Mangrulkar on 2024/02/20.
//

import Foundation
@testable import WeatherApplication

struct MockData {
    
    static let currentWeatherOffline = CurrentWeatherOffline(current: CurrentWeather(coord: nil, weather: nil, base: nil, main: nil, visibility: nil, wind: nil, rain: nil, clouds: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: "joburg", cod: nil), forecast: nil, isFav: nil, latitude: nil, longitude: nil)
    
    static let favouriteItemData = [CurrentWeatherOffline(current: CurrentWeather(coord: nil, weather: nil, base: nil, main: nil, visibility: nil, wind: nil, rain: nil, clouds: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: "joburg", cod: nil), forecast: nil, isFav: false, latitude: nil, longitude: nil)]
    
    static let favouriteItemDataWithFavouriteTrue = [CurrentWeatherOffline(current: CurrentWeather(coord: nil, weather: nil, base: nil, main: nil, visibility: nil, wind: nil, rain: nil, clouds: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: "joburg", cod: nil), forecast: nil, isFav: true, latitude: nil, longitude: nil)]
    
    static let currentWeather = CurrentWeather(coord: nil, weather: nil, base: nil, main: nil, visibility: nil, wind: nil, rain: nil, clouds: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: "joburg", cod: nil)
    
    static let currentWeatherNameNil = CurrentWeather(coord: nil, weather: nil, base: nil, main: nil, visibility: nil, wind: nil, rain: nil, clouds: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: "capetown", cod: nil)
    
    static let forecastWeather = ForecastWeatherResponse(cod: "123", message: 0, cnt: 0, list: [List(dt: nil, main: nil, weather: nil, clouds: nil, wind: nil, visibility: nil, pop: nil, rain: nil, sys: nil, dtTxt: nil)], city: City(id: nil, name: "joburg", coord: nil, country: nil, population: nil, timezone: nil, sunrise: nil, sunset: nil))
}
