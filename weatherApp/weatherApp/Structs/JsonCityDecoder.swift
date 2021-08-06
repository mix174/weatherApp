//
//  JsonCityDecoder.swift
//  weatherApp
//
//  Created by Mix174 on 04.08.2021.
//

struct CityDecoder: Codable {
    // Корневой массив
    let citiesArray: [City]
    
    enum CodingKeys: String, CodingKey {
        case citiesArray = "city"
    }
    // Вложенная структура, ценность представляет только name
    struct City: Codable {
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case name
        }
    }
}
