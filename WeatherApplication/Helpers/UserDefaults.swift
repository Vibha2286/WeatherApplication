//
//  UserDefaults.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/18.
//

import Foundation

final class UserDefault {
    
    /// Set favourite list
    /// - Parameter model: Offline model object
    static func setFavouriteList(model: [CurrentWeatherOffline]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(model) {
            UserDefaults.standard.set(encodedData, forKey: "FavouriteItems")
        }
        UserDefaults.standard.synchronize()

    }
    
    /// Get favourite list
    /// - Returns: Offline model object
    static func getFavouriteList() -> [CurrentWeatherOffline] {
        if let favouriteData = UserDefaults.standard.object(forKey: "FavouriteItems") as? Data {
            let decoder = JSONDecoder()
            if let offlineData = try? decoder.decode([CurrentWeatherOffline].self, from: favouriteData) {
                return offlineData
            }
        }
        return []
    }
    
    /// Remove favourite list
    static func removeFavouriteList() {
        UserDefaults.standard.removeObject(forKey: "FavouriteItems")
    }
    
    
}
