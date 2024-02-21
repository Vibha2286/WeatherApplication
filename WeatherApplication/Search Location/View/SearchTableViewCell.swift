//
//  SearchTableViewCell.swift
//  WeatherApplication
//
//  Created by Vibha Mangrulkar on 2024/02/20.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet private var cityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Upate cell UI to display data
    /// - Parameter item: Places details
    func updateUI(item: PlaceDetailsModel) {
        cityNameLabel.text = item.result.name
    }
}
