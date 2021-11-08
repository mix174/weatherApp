//
//  CityArrayModel.swift
//  weatherApp
//
//  Created by Mix174 on 04.08.2021.
//

final class CityModel {
    
    func сitiesSetup(citiesDecodable: CityDecodable) -> [String] {
        var cities: [String] = []
        for i in citiesDecodable.cities {
            cities.append(i.name)
        }
        return cities
    }
}
