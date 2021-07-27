//
//  UITableViewCell+extensions.swift
//  weatherApp
//
//  Created by Mix174 on 24.07.2021.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
