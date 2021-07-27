//
//  UICollectionViewCell+extensions.swift
//  weatherApp
//
//  Created by Mix174 on 25.07.2021.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
