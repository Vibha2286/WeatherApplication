//
//  DashboardTableViewCell.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/18.
//

import UIKit

final class DashboardTableViewCell: UITableViewCell {
    
    @IBOutlet private var dayNameLabel: UILabel!
    @IBOutlet private var weatherIndicatorIcon: UIImageView!
    @IBOutlet private var dayTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// Upate cell UI to display data
    /// - Parameter item: list model
    func updateUI(item: List) {
        if let epoach = item.dt {
            let date = Utility.convertEpochTimeToActualTime(epochTime: Double(epoach))
            let day = date.components(separatedBy: ",")
            if day.count > 0 { self.dayNameLabel.text = day[0] }
        }
        
        if let weatherArr = item.weather, let type = weatherArr[0].main {
            if type == "cloud".localized() || type == "mist".localized() {
                self.weatherIndicatorIcon.image = DynamicWeatherBackground.clear
            } else if type == "haze".localized() || type == "rain".localized() || type == "smoke".localized() || type == "drizzle".localized() {
                self.weatherIndicatorIcon.image = DynamicWeatherBackground.rain
            } else {
                self.weatherIndicatorIcon.image = DynamicWeatherBackground.partlySunny
            }
        }
        
        if let info = item.main, let tempValue = info.temp {
            self.dayTemperatureLabel.text = tempValue.convertToDegree()
        }
    }
}
