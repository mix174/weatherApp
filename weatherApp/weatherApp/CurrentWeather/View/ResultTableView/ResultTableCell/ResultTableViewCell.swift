//
//  ResultTableViewCell.swift
//  weatherApp
//
//  Created by Mix174 on 30.07.2021.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    // Нужно ли выносить в extension?
    static let nibName = "ResultTableViewCell"
    
    @IBOutlet private weak var cityLabel: UILabel!
    
    func cellSetup(city: String) {
        cityLabel.text = city
    }
}
