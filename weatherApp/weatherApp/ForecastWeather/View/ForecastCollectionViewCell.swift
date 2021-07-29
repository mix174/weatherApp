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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        apperanceSetup()
    }
    func apperanceSetup() {
        backgroundColor = UIColor(displayP3Red: 250, green: 250, blue: 250, alpha: 0.65)
        layer.cornerRadius = 10
    }
    
    func cellSetup(rowData: ForecastWeatherStruct) {
        date.text = rowData.date
        weekday.text = rowData.weekday
        windSpeed.attributedText = setMixedText(type: .windSpeed,
                                                indicator: rowData.windSpeed)
        humidity.attributedText = setMixedText(type: .humidity,
                                               indicator: rowData.humidity)
        icon.image = rowData.icon
        temp.text = rowData.temp
    }
    // Выбор показателя для лейбла
    enum IndicatorType: String {
        case humidity = "Влажность"
        case windSpeed = "Ветер"
    }
    // Установка текста
    func setMixedText(type: IndicatorType, indicator: String) -> NSMutableAttributedString {
        let attributedText =
            NSMutableAttributedString()
            .normal("\(type.rawValue)  ", fontSize: 20)
            .bold("\(indicator)", fontSize: 20)
        return attributedText
    }
}
