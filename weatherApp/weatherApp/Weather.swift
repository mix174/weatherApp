//
//  Weather.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import Foundation

struct Weather: Codable {
    struct City: Codable {
        let name: String
        let id: Int
    }
    
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case city = "city"
    }
    // Почитать про CodingKeys
    
}
