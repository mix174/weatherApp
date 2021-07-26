//
//  ForecastCollectionViewCell.swift
//  weatherApp
//
//  Created by Mix174 on 20.07.2021.
//

import UIKit

final class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var weekday: UILabel!
    @IBOutlet private weak var windSpeed: UILabel!
    @IBOutlet private weak var humidity: UILabel!
    @IBOutlet private weak var temp: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    
    func cellSetup(rowData: ForecastWeatherStruct) {
        date.text = rowData.date
        weekday.text = rowData.weekday
        windSpeed.text = rowData.windSpeed
        humidity.text = rowData.humidity
        temp.text = rowData.temp
        icon.image = rowData.icon
    }
}
