//
//  GrayLabel.swift
//  weatherApp
//
//  Created by Mix174 on 28.07.2021.
//
import UIKit
import SnapKit

final class GrayLabel: UIView {
    // Аутлеты
    @IBOutlet private weak var type: UILabel!
    @IBOutlet private weak var value: UILabel!
    
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
    
    // Установка констрейтов
    func setConstraints() {
        let superViewSnp = self.snp
        self.translatesAutoresizingMaskIntoConstraints = false
        type.snp.makeConstraints { make in
            make.top.equalTo(superViewSnp.top).inset(10)
            make.leading.equalTo(superViewSnp.leading).inset(15)
            make.trailing.equalTo(superViewSnp.trailing).inset(15)
        }
        value.snp.makeConstraints { make in
            make.top.equalTo(type.snp.bottom).offset(5)
            make.bottom.equalTo(superViewSnp.bottom).inset(10)
            make.leading.equalTo(type.snp.leading)
            make.trailing.equalTo(type.snp.trailing)
        }
    }
    func removeInnerConstraints() {
        type.snp.removeConstraints()
        value.snp.removeConstraints()
    }
}
