//
//  FavouriteWeatherLocationsViewController.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/18.
//

import UIKit

final class FavouriteWeatherLocationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var favouriteList = [CurrentWeatherOffline]()
    private var delegate: FavouriteWeatherLocationsViewModelDelegate?
    private var state: WeatherState?
    
    private var city = ""
    private var country = ""

    override func viewDidLoad() {
        super.viewDidLoad()
       configureUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "LocationDetailsSegue" {
            guard let locationDetailsViewController = segue.destination as? LocationDetailsViewController else {
                debugPrint("LocationDetailsViewController object is nil")
                return
            }
            locationDetailsViewController.set(city: city, country: country)
        }
    }
    
    func set(delegate: FavouriteWeatherLocationsViewModelDelegate, list: [CurrentWeatherOffline], state: WeatherState) {
        self.delegate = delegate
        self.favouriteList = list
        self.state = state
    }
    
    // MARK: Private
    
    private func configureUI() {
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.isHidden = false
        
        switch state {
        case .cloudy:
            tableView.backgroundColor = UIColor(hexString: Colors.cloudy)
        case .rainy:
           tableView.backgroundColor = UIColor(hexString: Colors.rainy)
        case .sunny:
            tableView.backgroundColor = UIColor(hexString: Colors.sunny)
        case .none: 
            tableView.backgroundColor = UIColor(hexString: Colors.sunny)
        }
    }
}

 // MARK: Tableview delegate method

extension FavouriteWeatherLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FavoriteLocationViewCell else {
            return UITableViewCell()
        }
        
        let item = favouriteList[indexPath.row]
        cell.updateUI(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favouriteData = favouriteList[indexPath.row]
        if let delegate = self.delegate {
            delegate.selectedFavourite(data: favouriteData)
            city = favouriteData.current?.name ?? ""
            country = favouriteData.forecast?.city.country ?? ""
            performSegue(withIdentifier: "LocationDetailsSegue", sender: self)
        }
    }
}
