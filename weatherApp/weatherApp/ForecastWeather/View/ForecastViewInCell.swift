//
//  ForecastViewInCell.swift
//  weatherApp
//
//  Created by Mix174 on 29.07.2021.
//

import UIKit

final class ForecastViewInCell: UIView {
    
    @IBOutlet private weak var weekday: UILabel!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var temp: UILabel!
    
    
    func cellSetup(rowData: LongForecastWeatherStruct) {
        weekday.text = rowData.weekday
        date.text = rowData.date
        icon.image = rowData.icon
        temp.text = rowData.temp
    }
}
