//
//  FavoriteLocationViewCell.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/18.
//

import UIKit

final class FavoriteLocationViewCell: UITableViewCell {
    
    @IBOutlet private var cityNameLabel: UILabel!
    @IBOutlet private var weatherIndicatorIcon: UIImageView!
    @IBOutlet private var dayTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Upate cell UI to display data
    /// - Parameter item: Current weather offline model
    func updateUI(item: CurrentWeatherOffline) {
        if let itemAtIndex = item.current, let cityName = itemAtIndex.name {
            cityNameLabel.text = cityName
            if let weatherArr = itemAtIndex.weather, let type = weatherArr[0].main {
                if type == "cloud".localized() || type == "mist".localized() {
                    weatherIndicatorIcon.image = DynamicWeatherBackground.clear
                    backgroundColor = UIColor(hexString: Colors.cloudy)
                } else if type == "haze".localized() || type == "rain".localized() || type == "smoke".localized() || type == "drizzle".localized() {
                    weatherIndicatorIcon.image = DynamicWeatherBackground.rain
                    backgroundColor = UIColor(hexString: Colors.rainy)
                } else {
                    weatherIndicatorIcon.image = DynamicWeatherBackground.partlySunny
                    backgroundColor = UIColor(hexString: Colors.sunny)
                }
            }
            
            if let info = itemAtIndex.main, let tempValue = info.temp {
                dayTemperatureLabel.text = tempValue.convertToDegree()
            }
        }
    }
}
