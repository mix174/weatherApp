//
//  ForecastTableViewCell.swift
//  weatherApp
//
//  Created by Mix174 on 13.07.2021.
//

import UIKit
import SnapKit

final class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewInCell: ForecastViewInCell!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        apperanceSetup()
    }
    
    func apperanceSetup() {
        viewInCell.backgroundColor = UIColor.alebaster065
        viewInCell.layer.cornerRadius = 10
    }
    
    func cellSetup(rowData: LongForecastWeatherStruct) {
        viewInCell.cellSetup(rowData: rowData)
    }
    
    func setConstrints() {
        viewInCell.snp.makeConstraints {make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        viewInCell.setConstrints()
    }
}
