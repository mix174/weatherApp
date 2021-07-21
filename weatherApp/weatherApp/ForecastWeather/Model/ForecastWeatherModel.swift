//
//  ForecastWeatherModel.swift
//  weatherApp
//
//  Created by Mix174 on 25.06.2021.
//

final class ForecastWeatherModel {
    
    func prepareWeatherModel(data: ForecastWeatherDecodable) -> [CurrentWeatherDecodable] {
        var array: [CurrentWeatherDecodable] = []
        
        let dataCount = data.partWeather.count
        var index = 0
        while index < dataCount {
            array.append(data.partWeather[index])
            index += 8
        }
        return array
    }
    
}
