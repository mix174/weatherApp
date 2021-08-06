//
//  GrayLabel.swift
//  weatherApp
//
//  Created by Mix174 on 28.07.2021.
//
import UIKit

final class GrayLabel: UIView {
    // Аутлеты
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var value: UILabel!
    
    // Автонастройка лейбла
    override func awakeFromNib() {
        super.awakeFromNib()
        appearanceSetup()
    }
    
    // Функция настройки лейбла
    func appearanceSetup() {
        backgroundColor = UIColor.alebaster065
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    // Выбор показателя для лейбла
    enum ParameterType: String {
        case humidity = "Влажность"
        case windSpeed = "Ветер"
    }
    
    // Установка текста
    func labelSetup(type: ParameterType, value: String) {
        self.type.text = type.rawValue
        self.value.text = value
    }
}
