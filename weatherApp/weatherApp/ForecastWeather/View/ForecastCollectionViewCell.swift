//
//  ForecastCollectionViewCell.swift
//  weatherApp
//
//  Created by Mix174 on 20.07.2021.
//

import UIKit

final class ForecastCollectionViewCell: UICollectionViewCell {
    // Аутлеты
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var weekday: UILabel!
    @IBOutlet private weak var temp: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    
    @IBOutlet private weak var windSpeedType: UILabel!
    @IBOutlet private weak var humidityType: UILabel!
    @IBOutlet private weak var windSpeedValue: UILabel!
    @IBOutlet private weak var humidityValue: UILabel!
    
    // Действия после загрузки
    override func awakeFromNib() {
        super.awakeFromNib()
        apperanceSetup()
    }
    
    // Настройка внешнего вида ячейки
    func apperanceSetup() {
        backgroundColor = UIColor.alebaster065
        layer.cornerRadius = 10
    }
    
    // Выбор показателя для лейбла
    enum ParameterType: String {
        case humidity = "Влажность"
        case windSpeed = "Ветер"
    }
    
    // Сборка ячейки
    func cellSetup(rowData: LongForecastWeatherStruct) {
        date.text = rowData.date
        weekday.text = rowData.weekday
        icon.image = rowData.icon
        temp.text = rowData.temp
        
        windSpeedType.text = ParameterType.windSpeed.rawValue
        windSpeedValue.text = rowData.windSpeed
        humidityType.text = ParameterType.humidity.rawValue
        humidityValue.text = rowData.humidity
    }
    
//    // Установка смешанного текста
//    func setMixedText(type: ParameterType, indicator: String) -> NSMutableAttributedString {
//        let attributedText =
//            NSMutableAttributedString()
//            .normal("\(type.rawValue)  ", fontSize: 20)
//            .bold("\(indicator)", fontSize: 20)
//        return attributedText
//    }
}
