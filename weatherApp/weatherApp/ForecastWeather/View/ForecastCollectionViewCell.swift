//
//  ForecastCollectionViewCell.swift
//  weatherApp
//
//  Created by Mix174 on 20.07.2021.
//

import UIKit

final class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var weekday: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    func cellSetup(rowData: CurrentWeatherDecodable) {
        date.text = rowData.date
        weekday.text = rowData.weekday
        windSpeed.text = rowData.wind.windSpeedConverted
        humidity.text = rowData.main.humidityConverted
        temp.text = rowData.main.tempConverted
        icon.image = rowData.weather[0].iconImage
    }
}
