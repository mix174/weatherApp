//
//  CurrentTableViewCell.swift
//  weatherApp
//
//  Created by Mix174 on 16.07.2021.
//

import UIKit

final class CurrentTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var temp: UILabel!
    
    func cellSetup(rowData: TableViewWeatherStruct) {
        time.text = rowData.time
        icon.image = rowData.icon
        temp.text = rowData.temp
    }
}
