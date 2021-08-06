//
//  CityArrayModel.swift
//  weatherApp
//
//  Created by Mix174 on 04.08.2021.
//

final class CityModel {
    
    func сitiesSetup(citiesDecodable: CityDecoder) -> [String] {
        var citiesArray: [String] = []
        for i in citiesDecodable.citiesArray {
            citiesArray.append(i.name)
        }
        return citiesArray
    }
}
