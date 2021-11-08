//
//  CurrentTableViewCell.swift
//  weatherApp
//
//  Created by Mix174 on 16.07.2021.
//

import UIKit
import SnapKit

final class CurrentTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var temp: UILabel!
    
    func cellSetup(rowData: ShortForecastWeatherStruct) {
        time.text = rowData.time
        icon.image = rowData.icon
        temp.text = rowData.temp
    }
    func setConstraints() {
        // перестает показывать currentTableView
//        self.translatesAutoresizingMaskIntoConstraints = false
        icon.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1.1)
            make.width.equalTo(50)
        }
        time.snp.makeConstraints {make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(icon.snp.leading)
        }
        temp.snp.makeConstraints {make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(icon.snp.trailing)
            make.trailing.equalToSuperview().inset(10)
        }
    }
}
