//
//  LocationDetailsViewController.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/20.
//

import UIKit

final class LocationDetailsViewController: UIViewController {
    
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var countryNameLabel: UILabel!
    
    private var city = ""
    private var country = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        cityNameLabel.text = city
        countryNameLabel.text = country
    }
    
    func set(city: String, country: String) {
        self.city = city
        self.country = country
    }
}
