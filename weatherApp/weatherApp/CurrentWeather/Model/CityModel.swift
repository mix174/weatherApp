//
//  CityArrayModel.swift
//  weatherApp
//
//  Created by Mix174 on 04.08.2021.
//

final class CityModel {
    
    func cityArraySetup(cityMassStruct: CityDecoder) -> [String] {
        
        let cityStructArray = cityMassStruct.cityArray
        var cityArray: [String] = []
        for i in cityStructArray {
            cityArray.append(i.name)
        }
        return cityArray
    }
}
