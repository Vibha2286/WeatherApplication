//
//  DashboardViewController.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/17.
//

import UIKit

final class DashboardViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var backgroundWeatherImage: UIImageView!
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var degreeLabel: UILabel!
    @IBOutlet private var currentWeatherStatusLabel: UILabel!
    @IBOutlet private var temperatureView: UIView!
    @IBOutlet private var mininumTemperatureLabel: UILabel!
    @IBOutlet private var maximumTemperatureLabel: UILabel!
    @IBOutlet private var currentTemperatureLabel: UILabel!
    @IBOutlet private var favoriteButton: UIButton!
    @IBOutlet private var statusTimeLabel: UILabel!
    
    private let loader = UIAlertController(title: nil, 
                                           message: "PleaseWait".localized(),
                                           preferredStyle: .alert)
    private lazy var viewModel = DashboardViewModel(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.checkInternetConnectivity()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "FavouriteWeatherLocationsViewSegue":
            guard let favouriteViewController = segue.destination as? FavouriteWeatherLocationsViewController else {
                debugPrint("FavouriteWeatherLocationsViewController object is nil")
                return
            }
            favouriteViewController.set(delegate: self, list: viewModel.favouriteItemsArray, state: viewModel.weatherState)
        case "SearchViewSegue":
            guard let searchViewController = segue.destination as? SearchLocationViewController else {
                debugPrint("SearchLocationViewController object is nil")
                return
            }
            searchViewController.onLocationSelected = { location in
                self.viewModel.getAPIData(latitude: location.lat, longitude: location.lng)
            }
        default: break
        }
    }
    
    @IBAction private func reloadButtonTapped(_ sender: Any) {
        viewModel.checkInternetConnectivity()
    }
    
    @IBAction private func favoriteButtonTapped(_ sender: Any) {
        viewModel.updateFavouriteStatus()
    }
    
    @IBAction private func showFavoriteListButtonTapped(_ sender: Any) {
        viewModel.moveToFavouriteList()
    }
    
    @IBAction private func mapButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "MapViewSegue", sender: self)
    }
    
    @IBAction private func searchLocationButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "SearchViewSegue", sender: self)
    }
}

//MARK:- Tableview delegate and datasource
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DashboardTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.displayItemsArray[indexPath.row]
        cell.updateUI(item: item)
        return cell
    }
}

 //MARK:  DashboardViewModelDelegate

extension DashboardViewController: DashboardViewModelDelegate {
    
    func showLoader() {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        loader.view.addSubview(loadingIndicator)
        parent?.present(loader, animated: true)
    }
    
    func dismissLoader() {
        loader.dismiss(animated: true, completion: nil)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func setCityName(_ name: String) {
        cityLabel.text = name
    }
    
    func weatherState(_ state: String) {
        currentWeatherStatusLabel.text = state
    }
    
    func setMinimumTemperature(_ temperature: String) {
        mininumTemperatureLabel.text = temperature
    }
    
    func setMaximumTemperature(_ temperature: String) {
        maximumTemperatureLabel.text = temperature
    }
    
    func setCurrentTemperature(_ temperature: String) {
        currentTemperatureLabel.text = temperature
        degreeLabel.text = temperature
    }
    
    func setLastUpdatedTime(_ time: String) {
        statusTimeLabel.text = time
    }

    func changeTheme(state: WeatherState) {
        switch state {
        case .cloudy:
            backgroundWeatherImage.image = DynamicWeatherBackground.forestCloudy
            tableView.backgroundColor = UIColor(hexString: Colors.cloudy)
            temperatureView.backgroundColor = UIColor(hexString: Colors.cloudy)
        case .rainy:
           backgroundWeatherImage.image = DynamicWeatherBackground.forestRainy
           tableView.backgroundColor = UIColor(hexString: Colors.rainy)
            temperatureView.backgroundColor = UIColor(hexString: Colors.rainy)
        case .sunny:
            backgroundWeatherImage.image = DynamicWeatherBackground.forestSunny
            tableView.backgroundColor = UIColor(hexString: Colors.sunny)
            temperatureView.backgroundColor = UIColor(hexString: Colors.sunny)
        }
    }
    
    func updateFavoriteStatus(image: UIImage?) {
        favoriteButton.setImage(image, for: .normal)
    }
    
    func navigateToFavoriteListScreen() {
        performSegue(withIdentifier: "FavouriteWeatherLocationsViewSegue", sender: self)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { _ in
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: FavouriteWeatherLocationsViewModelDelegate

extension DashboardViewController: FavouriteWeatherLocationsViewModelDelegate {
    
    func selectedFavourite(data: CurrentWeatherOffline) {
        viewModel.reloadViewWithOfflineData(weatherData: data)
    }
}
