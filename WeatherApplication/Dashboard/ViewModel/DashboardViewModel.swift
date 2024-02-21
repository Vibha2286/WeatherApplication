//
//  DashboardViewModel.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/17.
//

import UIKit
import CoreLocation

protocol DashboardViewModelDelegate: AnyObject {
    
    func showLoader()
    func dismissLoader()
    func reloadTableView()
    func setCityName(_ name: String)
    func weatherState(_ state: String)
    func setMinimumTemperature(_ temperature: String)
    func setMaximumTemperature(_ temperature: String)
    func setCurrentTemperature(_ temperature: String)
    func setLastUpdatedTime(_ time: String)
    func changeTheme(state: WeatherState)
    func updateFavoriteStatus(image: UIImage?)
    func navigateToFavoriteListScreen()
    func showAlert(message: String)
}

protocol FavouriteWeatherLocationsViewModelDelegate: AnyObject {
    
    func selectedFavourite(data: CurrentWeatherOffline)
}

final class DashboardViewModel {
    
    private weak var delegate: DashboardViewModelDelegate?
    private let client = WeatherAPIClient()
    var currentWeather: CurrentWeather?
    var forecastWeather: ForecastWeatherResponse?
    var locationAccess = true
    var favouriteItemsArray = [CurrentWeatherOffline]()
    private(set) var displayItemsArray = [List]()
    private(set) var weatherState: WeatherState = .sunny
    private(set) var weatherName: String = ""
    private(set) var getLatitude = 0.0
    private(set) var getLongitude = 0.0
    
    // MARK: Initialisation
    
    /// Initialize view and array
    /// - Parameter view: Dashbaord view
    init(delegate: DashboardViewModelDelegate) {
        self.delegate = delegate
        self.favouriteItemsArray = UserDefault.getFavouriteList()
    }
    
    // MARK: Public Methods
            
    /// Current weather favourite & unfavourite logic
    func updateFavouriteStatus() {
        let globalObject = CurrentWeatherOffline(current: currentWeather,
                                                 forecast: forecastWeather,
                                                 isFav: false,
                                                 latitude: getLatitude,
                                                 longitude: getLongitude)
        
        if self.favouriteItemsArray.count > 0 {
            if let currentObject = globalObject.current, favouriteItemsArray.contains(where: { (item) -> Bool in
                if item.current?.name == currentObject.name, let isFavourite = item.isFav {
                    if isFavourite {
                        self.favouriteItemsArray.removeAll(where: { (object) -> Bool in
                            if let objCityName = object.current?.name, objCityName == item.current?.name {
                                var object = object
                                object.isFav = false
                                delegate?.updateFavoriteStatus(image: DynamicWeatherBackground.unFavourite)
                                delegate?.showAlert(message: "unFavourite.message".localized())
                                return true
                            }
                            return false
                        })
                    } else if let isFavourite = item.isFav, !isFavourite {
                        var object = item
                        object.current = currentObject
                        addFavouriteObjectInArray(object: object)
                        return true
                    }
                    return true
                }
                return false
            }) { } else {
                //Called when doesn't match with existing object in offline model
                addFavouriteObjectInArray(object: globalObject)
            }
        } else {
            //Called when array is empty
            guard let _ = self.currentWeather, let _ = self.forecastWeather else {
                delegate?.showAlert(message: "invalid.data.message".localized())
                return
            }
            addFavouriteObjectInArray(object: globalObject)
        }
        UserDefault.setFavouriteList(model: favouriteItemsArray)
    }
        
    /// Navigate to favourite list
    func moveToFavouriteList() {
        if !favouriteItemsArray.isEmpty {
            delegate?.navigateToFavoriteListScreen()
        }else {
            delegate?.showAlert(message: "list.empty.message".localized())
        }
    }
            
    /// Location manager notification callback method
    /// - Parameter notification: Notification object
    @objc func handleLocationManagerSelector(withNotification notification : NSNotification) {
        let checkAccess = checkLocationAccessStatus()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "location.access.notification".localized()), object: nil)
        if !checkAccess {
            fetchLocationAndAPICall()
        }
    }
    
    /// Check internet connectivity and call API or update UI based on saved favourite list
    func checkInternetConnectivity() {
        if !Reachability.isConnectedToNetwork() {
            if self.favouriteItemsArray.count > 0, let lastWeather = self.favouriteItemsArray.last {
                reloadViewWithOfflineData(weatherData: lastWeather)
                delegate?.showAlert(message: "offline.data.display.message".localized())
                return
            }
            delegate?.showAlert(message: "internet.unavailable.message".localized())
        }else {
            addLocationNotificationObsever()
        }
    }
    
    /// Add notification observer for notifying the location changes
    func addLocationNotificationObsever() {
        let checkAccess = checkLocationAccessStatus()
        if checkAccess {
            NotificationCenter.default.addObserver(self, selector: #selector(handleLocationManagerSelector(withNotification:)), name: NSNotification.Name(rawValue: "location.access.notification".localized()), object: nil)
        }else {
            fetchLocationAndAPICall()
        }
    }
    
    /// Reload data in offline mode
    /// - Parameter weatherData: Offline weather object
    func reloadViewWithOfflineData(weatherData: CurrentWeatherOffline) {
        currentWeather = weatherData.current
        forecastWeather = weatherData.forecast
        updateView()
    }
    
    // MARK: Private
    
    /// Fetch updated current location and API call
    private func fetchLocationAndAPICall() {
        getLatitude = LocationManager.sharedInstance.locationCoordinate.latitude
        getLongitude = LocationManager.sharedInstance.locationCoordinate.longitude
        getAPIData(latitude: getLatitude, longitude: getLongitude)
    }
    
    /// Get weather and forecast data from the API
    func getAPIData(latitude: Double, longitude: Double) {
        getLatitude = latitude
        getLongitude = longitude
        delegate?.showLoader()
        
        client.fetchCurrentWeatherDetails(lat: latitude, long: longitude) { [weak self] currentWeather, error in
            guard let currentWeather = currentWeather else {
                self?.delegate?.dismissLoader()
                return
            }
            self?.delegate?.dismissLoader()
            self?.currentWeather = currentWeather
        }
        
        client.fetchWeatherForecast(lat: latitude, long: longitude) { [weak self] forecastWeatherResponse, error in
            guard let forecastWeatherResponse = forecastWeatherResponse else { return }
            self?.delegate?.dismissLoader()
            self?.forecastWeather = forecastWeatherResponse
            self?.updateView()
        }
    }
    
    /// Set weather state to dispaly UI accordingly
    /// - Parameter type: state type
    func setWeatherState(type: Int) {
        var state: WeatherState = .sunny
        var weather = ""
        if type == 0 {
            state = .cloudy
            weather = "cloudyWeather".localized()
        } else if type == 1 {
            state = .rainy
            weather = "RainyWeather".localized()
        } else {
            state = .sunny
            weather = "sunnyWeather".localized()
        }
        weatherState = state
        weatherName = weather
        delegate?.weatherState(weather)
        delegate?.changeTheme(state: state)
    }
    
    /// Set the forecast data to dispaly on the UI
    func setForecastData() {
        if let forecast = self.forecastWeather {
            displayItemsArray = forecast.configureForecastDetails()
            delegate?.reloadTableView()
        }
    }
    
    /// Set weather data to dispaly on the UI
    private func setWeatherData() {
        delegate?.setCityName(currentWeather?.name ?? "")
        delegate?.setMinimumTemperature((currentWeather?.main?.tempMin ?? 0.0).convertToDegree())
        delegate?.setMaximumTemperature((currentWeather?.main?.tempMax ?? 0.0).convertToDegree())
        delegate?.setCurrentTemperature((currentWeather?.main?.temp ?? 0.0).convertToDegree())
        setWeatherState(type: currentWeather?.sys?.type ?? 0)
    }
    
    /// Add current weather object in the favourite array
    /// - Parameter object: Current weather object
    private func addFavouriteObjectInArray(object: CurrentWeatherOffline) {
        var globalObject = object
        delegate?.updateFavoriteStatus(image: DynamicWeatherBackground.favourite)
        delegate?.showAlert(message: "favourite.message".localized())
        globalObject.isFav = true
        globalObject.latitude = getLatitude
        globalObject.longitude = getLongitude
        favouriteItemsArray.append(globalObject)
    }
    
    /// Update favourite & unfavourite image according to data present in the favourite array
    @discardableResult
    func updateFavouriteImage() -> Bool {
        return favouriteItemsArray.contains(where: { (item) -> Bool in
            if let itemWeatherName = item.current?.name, let currentWeatherName = currentWeather?.name {
                if itemWeatherName != currentWeatherName {
                    delegate?.updateFavoriteStatus(image: DynamicWeatherBackground.unFavourite)
                } else {
                    delegate?.updateFavoriteStatus(image: DynamicWeatherBackground.favourite)
                    return true
                }
            }
            return false
        })
    }
    
    /// Check for Location access status
    private func checkLocationAccessStatus() -> Bool {
        let manager = CLLocationManager()
        let authorizationStatus: CLAuthorizationStatus

        if #available(iOS 14, *) {
            authorizationStatus = manager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        switch authorizationStatus{
        case .notDetermined:
            locationAccess = true
        case .restricted:
            locationAccess = true
        case .denied:
            locationAccess = true
        case .authorizedAlways:
            locationAccess = false
        case .authorizedWhenInUse:
            locationAccess = false
        @unknown default: break
        }
        return locationAccess
    }
    
    /// Display the last updated time for API call
    private func lastUpdatedTime() {
      delegate?.setLastUpdatedTime(currentWeather?.lastUpdatedTime ?? "")
    }
    
    /// Update UI
    func updateView() {
        setWeatherData()
        setForecastData()
        updateFavouriteImage()
        lastUpdatedTime()
    }
}
