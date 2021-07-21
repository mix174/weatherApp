//
//  ForecastTableViewCell.swift
//  weatherApp
//
//  Created by Mix174 on 13.07.2021.
//

import UIKit

final class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weekday: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temp: UILabel!
    
    func cellSetup(rowData: CurrentWeatherDecodable) {
        weekday.text = rowData.weekday
        date.text = rowData.date
        icon.image = rowData.weather[0].iconImage
        temp.text = rowData.main.tempConverted
    }
}
