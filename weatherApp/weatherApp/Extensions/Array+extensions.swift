//
//  Array+extensions.swift
//  weatherApp
//
//  Created by Mix174 on 26.07.2021.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
