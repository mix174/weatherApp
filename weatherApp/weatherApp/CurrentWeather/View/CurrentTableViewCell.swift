//
//  CurrentTableViewCell.swift
//  weatherApp
//
//  Created by Mix174 on 16.07.2021.
//

import UIKit

final class CurrentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temp: UILabel!
    
    func cellSetup(rowData: CurrentWeatherDecodable) {
        time.text = rowData.time
        icon.image = rowData.weather[0].iconImage
        temp.text = rowData.main.tempConverted
    }
}
