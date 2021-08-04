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
    @IBOutlet private weak var windSpeed: UILabel!
    @IBOutlet private weak var humidity: UILabel!
    @IBOutlet private weak var temp: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    
    // Действия после загрузки
    override func awakeFromNib() {
        super.awakeFromNib()
        apperanceSetup()
    }
    
    // Настройка внешнего вида ячейки
    func apperanceSetup() {
        backgroundColor = UIColor(displayP3Red: 250, green: 250, blue: 250, alpha: 0.65)
        layer.cornerRadius = 10
    }
    
    // Сборка ячейки
    func cellSetup(rowData: LongForecastWeatherStruct) {
        date.text = rowData.date
        weekday.text = rowData.weekday
        windSpeed.attributedText = setMixedText(type: .windSpeed,
                                                indicator: rowData.windSpeed)
        humidity.attributedText = setMixedText(type: .humidity,
                                               indicator: rowData.humidity)
        icon.image = rowData.icon
        temp.text = rowData.temp
    }
    
    // MARK: Работа со смешанным текстом в лейблах
    // Выбор показателя для лейбла
    enum ParameterType: String {
        case humidity = "Влажность"
        case windSpeed = "Ветер"
    }
    // Установка смешанного текста
    func setMixedText(type: ParameterType, indicator: String) -> NSMutableAttributedString {
        let attributedText =
            NSMutableAttributedString()
            .normal("\(type.rawValue)  ", fontSize: 20)
            .bold("\(indicator)", fontSize: 20)
        return attributedText
    }
}
