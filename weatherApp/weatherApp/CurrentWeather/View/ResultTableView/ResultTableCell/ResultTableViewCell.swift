//
//  ResultTableViewCell.swift
//  weatherApp
//
//  Created by Mix174 on 30.07.2021.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var cityLabel: UILabel!
    
    func cellSetup(city: String) {
        cityLabel.text = city
    }
}
