//
//  JsonCityDecoder.swift
//  weatherApp
//
//  Created by Mix174 on 04.08.2021.
//

struct CityDecodable: Codable {
    // Корневой массив
    let cities: [City]
    
    enum CodingKeys: String, CodingKey {
        case cities = "city"
    }
    // Вложенная структура, ценность представляет только name
    struct City: Codable {
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case name
        }
    }
}
