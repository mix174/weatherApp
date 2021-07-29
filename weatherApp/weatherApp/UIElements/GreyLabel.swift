//
//  GreyLabel.swift
//  weatherApp
//
//  Created by Mix174 on 28.07.2021.
//

import UIKit
// ошибка в названии
final class GreyLabel: UILabel {
    
    // Автонастройка лейбла
    override func awakeFromNib() {
        super.awakeFromNib()
        appearanceSetup()
    }
    // Функция настройки лейбла
    func appearanceSetup() {
        backgroundColor = UIColor(displayP3Red: 250, green: 250, blue: 250, alpha: 0.75)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    // Работа со смешанным текстом в лейблах
    // Выбор показателя для лейбла
    enum IndicatorType: String {
        case humidity = "Влажность"
        case windSpeed = "Ветер"
    }
    // Установка текста
    func set2LineText(type: IndicatorType, secondLine: String) {
        attributedText =
            NSMutableAttributedString()
            .normal("\(type.rawValue)\n", fontSize: 21)
            .bold("\(secondLine)", fontSize: 21)
    }
}
