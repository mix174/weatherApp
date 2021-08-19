//
//  ForecastViewInCell.swift
//  weatherApp
//
//  Created by Mix174 on 29.07.2021.
//

import UIKit
import SnapKit

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
    
    func setConstrints() {
        icon.snp.makeConstraints {make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1.1)
            make.width.equalTo(50)
        }
        weekday.snp.makeConstraints {make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(icon.snp.leading).offset(-10)
        }
        date.snp.makeConstraints {make in
            make.top.greaterThanOrEqualTo(weekday.snp.bottom).offset(5)
            make.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalTo(weekday)
        }
        temp.snp.makeConstraints {make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(icon.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
