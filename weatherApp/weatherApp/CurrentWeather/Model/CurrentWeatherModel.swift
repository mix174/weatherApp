//
//  OpenWeatherModel.swift
//  weatherApp
//
//  Created by Mix174 on 11.06.2021.
//
import UIKit

final class CurrentWeatherModel {
    
    func weatherStructSetup(currentWeather: CurrentWeatherDecodable) -> CurrentWetherStruct {
        // Возможно нужнa проверка
        let weatherStruct = CurrentWetherStruct(locationDraft: currentWeather.city ?? "not set",
                                                description: currentWeather.weather.description,
                                                icon: currentWeather.weather.iconImage ?? UIImage(imageLiteralResourceName: "none"),
                                                temp: currentWeather.main.temp,
                                                humidity: currentWeather.main.humidity,
                                                windSpeed: currentWeather.wind.windSpeed,
                                                backgroundImage: currentWeather.weather.backgroundImage ?? UIImage(imageLiteralResourceName: "BG-NormalWeather")) // как делать правильно?
        return weatherStruct
    }
    func weatherStructSetup(forecastWeather: ForecastWeatherDecodable) -> [ShortForecastWeatherStruct] {
        var tableViewArray: [ShortForecastWeatherStruct] = []
        
        for i in 0...6 {
            guard let weatherPart = forecastWeather.partWeather[safe: i] else { break }
            let tableViewWeather = ShortForecastWeatherStruct(time: weatherPart.time,
                                                          icon: weatherPart.weather.iconImage ?? UIImage(imageLiteralResourceName: "none"),
                                                          temp: weatherPart.main.temp)
            tableViewArray.append(tableViewWeather)
        }
        return tableViewArray
    }
}
