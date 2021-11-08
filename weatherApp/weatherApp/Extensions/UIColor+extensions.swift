//
//  UIColor+extensions.swift
//  weatherApp
//
//  Created by Mix174 on 05.08.2021.
//

import UIKit

extension UIColor {
    class var alebaster: UIColor {
        guard let alebasterColor = UIColor(named: "Alebaster") else {
            print("Color named \"Alebaster\" not found in Assets. White color returned instead")
            return .white
        }
        return alebasterColor
    }
    class var alebaster065: UIColor {
        guard let alebasterColor = UIColor(named: "Alebaster-0.65") else {
            print("Color named \"Alebaster-0.65\" not found in Assets. White color returned instead")
            return .white
        }
        return alebasterColor
    }
}
