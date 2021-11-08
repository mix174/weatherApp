//
//  Array+extensions.swift
//  weatherApp
//
//  Created by Mix174 on 25.08.2021.
//

extension Array {
    subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
