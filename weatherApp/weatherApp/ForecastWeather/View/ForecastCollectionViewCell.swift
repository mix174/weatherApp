//
//  ForecastCollectionViewCell.swift
//  weatherApp
//
//  Created by Mix174 on 20.07.2021.
//

import UIKit
import SnapKit

final class ForecastCollectionViewCell: UICollectionViewCell {
    // MARK: Аутлеты
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
    
    // MARK: Сборка ячейки
    func cellSetup(itemData: LongForecastWeatherStruct) {
        date.text = itemData.date
        weekday.text = itemData.weekday
        icon.image = itemData.icon
        temp.text = itemData.temp
        windSpeedType.text = ParameterType.windSpeed.rawValue
        windSpeedValue.text = itemData.windSpeed
        humidityType.text = ParameterType.humidity.rawValue
        humidityValue.text = itemData.humidity
    }
    // MARK: Констрейнты
    // Установка констрейнтов
    func setConstraints() {
        date.snp.makeConstraints {make in
            make.top.equalToSuperview().inset(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        weekday.snp.makeConstraints {make in
            make.top.equalTo(date.snp.bottom).offset(5)
            make.leading.trailing.equalTo(date)
        }
        humidityType.snp.makeConstraints {make in
            make.leading.equalTo(date)
            make.bottom.equalToSuperview().inset(10)
        }
        windSpeedType.snp.makeConstraints {make in
            make.leading.equalTo(date)
            make.bottom.equalTo(humidityType.snp.top).offset(-5)
            make.top.greaterThanOrEqualTo(weekday.snp.bottom).offset(10)
        }
        humidityValue.snp.makeConstraints {make in
            make.top.bottom.equalTo(humidityType)
            make.leading.equalTo(humidityType.snp.trailing).offset(10)
        }
        windSpeedValue.snp.makeConstraints {make in
            make.top.bottom.equalTo(windSpeedType)
            make.leading.equalTo(windSpeedType.snp.trailing).offset(10)
        }
        temp.snp.contentHuggingHorizontalPriority = 249
        temp.snp.makeConstraints {make in
            make.bottom.equalToSuperview().inset(25)
            make.leading.equalTo(humidityValue.snp.trailing)
            make.trailing.equalToSuperview().inset(5)
            make.height.equalToSuperview().multipliedBy(0.35)
        }
        icon.snp.makeConstraints {make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.equalTo(windSpeedType.snp.trailing)
            make.trailing.equalToSuperview().inset(40)
        }
    }
}
