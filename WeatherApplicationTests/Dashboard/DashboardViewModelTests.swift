//
//  DashboardViewModelTests.swift
//  WeatherApplicationTests
//
//  Created by Vibha Mangrulkar on 2024/02/20.
//

import XCTest
@testable import WeatherApplication

final class DashboardViewModelTests: XCTestCase {
    
    private var systemUnderTest: DashboardViewModel!
    private var mockDelegate = MockDashboardDelegate()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        systemUnderTest = DashboardViewModel(delegate: mockDelegate)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        systemUnderTest = nil
    }
    
    func testThatUpdateFavouriteStatusWhenContainDataButWeatherNameSame() {
        systemUnderTest.favouriteItemsArray = MockData.favouriteItemDataWithFavouriteTrue
        systemUnderTest.currentWeather = MockData.currentWeather
        systemUnderTest.updateFavouriteStatus()
        XCTAssertTrue(mockDelegate.updateFavouriteStatus)
        XCTAssertEqual(mockDelegate.alertText, "Current weather removed from the favourite list")
    }
    
    func testThatUpdateFavouriteStatusWhenContainDataButWeatherNameDifferent() {
        systemUnderTest.favouriteItemsArray = MockData.favouriteItemData
        systemUnderTest.updateFavouriteStatus()
        XCTAssertTrue(mockDelegate.updateFavouriteStatus)
        XCTAssertEqual(mockDelegate.alertText, "Current weather details added in the favourite list")
        XCTAssertGreaterThan(systemUnderTest.favouriteItemsArray.count, 0)
        
        systemUnderTest.currentWeather = MockData.currentWeather
        systemUnderTest.updateFavouriteStatus()
    }
    
    func testThatUpdateFavouriteStatusWhenFavouriteItemEmtpy() {
        systemUnderTest.favouriteItemsArray.removeAll()
        systemUnderTest.updateFavouriteStatus()
        XCTAssertEqual(mockDelegate.alertText, "Unable to do favourite, invalid data")
        
        
        systemUnderTest.currentWeather = MockData.currentWeather
        systemUnderTest.forecastWeather = MockData.forecastWeather
        systemUnderTest.updateFavouriteStatus()
        XCTAssertTrue(mockDelegate.updateFavouriteStatus)
    }
    
    func testThatMoveToFavouriteListWithSuccess() {
        let currentWeather = CurrentWeatherOffline()
        systemUnderTest.favouriteItemsArray.append(currentWeather)
        systemUnderTest.moveToFavouriteList()
        XCTAssertTrue(mockDelegate.navigateToFavouriteList)
        XCTAssertEqual(mockDelegate.alertText, "")
    }
    
    func testThatMoveToFavouriteListWithError() {
        systemUnderTest.favouriteItemsArray.removeAll()
        systemUnderTest.moveToFavouriteList()
        XCTAssertFalse(mockDelegate.navigateToFavouriteList)
        XCTAssertEqual(mockDelegate.alertText, "Favourite list is empty")
    }
    
    func testThatHandleLocationManagerSelector() {
        systemUnderTest.handleLocationManagerSelector(withNotification: NSNotification(name: NSNotification.Name(rawValue: "location.access.notification".localized()), object: nil))
        XCTAssertFalse(systemUnderTest.locationAccess)
    }
    
    func testThatCheckInternetConnectivityWhenNoNetwork() {
        UserDefault.removeFavouriteList()
        systemUnderTest.favouriteItemsArray.removeAll()
        systemUnderTest.checkInternetConnectivity()
        
        if !Reachability.isConnectedToNetwork() {
            XCTAssertEqual(mockDelegate.alertText, "Internet connection not available")
        }
    }
    
    func testThatCheckInternetConnectivityWhenNoNetworkContainOfflineData() {
        UserDefault.setFavouriteList(model: [CurrentWeatherOffline()])
        systemUnderTest.favouriteItemsArray = UserDefault.getFavouriteList()
        systemUnderTest.checkInternetConnectivity()
        
        if !Reachability.isConnectedToNetwork() {
            XCTAssertEqual(mockDelegate.alertText, "Internet connection not available.\nLast favourite offline data displayed")
            XCTAssertTrue(mockDelegate.cityName)
            XCTAssertTrue(mockDelegate.weatherState)
            XCTAssertTrue(mockDelegate.minimumTemperature)
            XCTAssertTrue(mockDelegate.maximumTemperature)
        }
    }
    
    func testThatCheckLocationAccessStatusWhenItIsNotGranted() {
        systemUnderTest.checkInternetConnectivity()
        XCTAssertFalse(systemUnderTest.locationAccess)
    }
    
    func testThatFetchLocationAndAPICallWhenSuccess() {
        systemUnderTest.checkInternetConnectivity()
        XCTAssertNotEqual(systemUnderTest.getLatitude, 0.000000)
        XCTAssertNotEqual(systemUnderTest.getLongitude, 0.000000)
        XCTAssertTrue(mockDelegate.displayLoader)
    }
    
    func testThatUpdateView() {
        systemUnderTest.updateView()
        
        XCTAssertTrue(mockDelegate.cityName)
        XCTAssertTrue(mockDelegate.weatherState)
        XCTAssertTrue(mockDelegate.minimumTemperature)
        XCTAssertTrue(mockDelegate.maximumTemperature)
        XCTAssertTrue(mockDelegate.currentTemperature)
        
    }
    
    func testThatUpdateFavouriteImageWhenFavouriteEmpty() {
        systemUnderTest.favouriteItemsArray = [CurrentWeatherOffline()]
        XCTAssertFalse(systemUnderTest.updateFavouriteImage())
        
        
        UserDefault.removeFavouriteList()
        XCTAssertFalse(systemUnderTest.updateFavouriteImage())
    }
    
    func testThatUpdateFavouriteImageContainDataAndWeatherSame() {
        systemUnderTest.favouriteItemsArray = MockData.favouriteItemData
        systemUnderTest.currentWeather = MockData.currentWeather
        XCTAssertTrue(systemUnderTest.updateFavouriteImage())
        XCTAssertTrue(mockDelegate.updateFavouriteStatus)
    }
    
    func testThatUpdateFavouriteImageContainDataAndWeatherNotSame() {
        systemUnderTest.favouriteItemsArray = MockData.favouriteItemData
        systemUnderTest.currentWeather = MockData.currentWeatherNameNil
        XCTAssertFalse(systemUnderTest.updateFavouriteImage())
        XCTAssertTrue(mockDelegate.updateFavouriteStatus)
    }
    
    func testThatSetForecastData() {
        systemUnderTest.forecastWeather = MockData.forecastWeather
        systemUnderTest.setForecastData()
        XCTAssertTrue(mockDelegate.reloadTable)
    }
    
    func testThatSetWeatherState() {
        systemUnderTest.setWeatherState(type: 0)
        XCTAssertEqual(systemUnderTest.weatherState, .cloudy)
        XCTAssertEqual(systemUnderTest.weatherName, "CLOUDY")
        
        systemUnderTest.setWeatherState(type: 1)
        XCTAssertEqual(systemUnderTest.weatherState, .rainy)
        XCTAssertEqual(systemUnderTest.weatherName, "RAINY")
        
        systemUnderTest.setWeatherState(type: 2)
        XCTAssertEqual(systemUnderTest.weatherState, .sunny)
        XCTAssertEqual(systemUnderTest.weatherName, "SUNNY")
    }
    
    func testThatReloadViewWithOfflineData() {
        systemUnderTest.reloadViewWithOfflineData(weatherData: MockData.currentWeatherOffline)
    }
}

final class MockDashboardDelegate: DashboardViewModelDelegate {
    
    var alertText = ""
    var navigateToFavouriteList = false
    var cityName = false
    var weatherState = false
    var minimumTemperature = false
    var maximumTemperature = false
    var displayLoader = false
    var hideLoader = false
    var currentTemperature = false
    var updateFavouriteStatus = false
    var reloadTable = false
    
    func showLoader() {
        displayLoader = true
    }
    
    func dismissLoader() {
        hideLoader = true
    }
    
    func reloadTableView() {
        reloadTable = true
    }
    
    func setCityName(_ name: String) {
        cityName = true
    }
    
    func weatherState(_ state: String) {
        weatherState = true
    }
    
    func setMinimumTemperature(_ temperature: String) {
        minimumTemperature = true
    }
    
    func setMaximumTemperature(_ temperature: String) {
        maximumTemperature = true
    }
    
    func setCurrentTemperature(_ temperature: String) {
        currentTemperature = true
    }
    
    func setLastUpdatedTime(_ time: String) { }
    
    func changeTheme(state: WeatherApplication.WeatherState) { }
    
    func updateFavoriteStatus(image: UIImage?) {
        updateFavouriteStatus = true
    }
    
    func navigateToFavoriteListScreen() {
        navigateToFavouriteList = true
    }
    
    func showAlert(message: String) {
        alertText = message
    }
}
