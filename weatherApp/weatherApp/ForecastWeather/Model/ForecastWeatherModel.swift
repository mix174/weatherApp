//
//  ForecastWeatherModel.swift
//  weatherApp
//
//  Created by Mix174 on 25.06.2021.
//
import UIKit

final class ForecastWeatherModel {
    
    func weatherStructSetup(forecastWeather: ForecastWeatherDecodable) -> [ForecastWeatherStruct] {
        var forecastArray: [ForecastWeatherStruct] = []
        guard let weatherItemFirst = forecastWeather.partWeather.first else { return forecastArray }
        for weatherItem in forecastWeather.partWeather {
            if weatherItem.time == weatherItemFirst.time {
                let forecastWeatherStruct = ForecastWeatherStruct(time: weatherItem.time,
                                                                  date: weatherItem.date,
                                                                  weekday: weatherItem.weekday,
                                                                  location: forecastWeather.cityForecast.city,
                                                                  icon: weatherItem.weather.iconImage ?? UIImage(imageLiteralResourceName: "none"),
                                                                  temp: weatherItem.main.temp,
                                                                  humidity: weatherItem.main.humidity,
                                                                  windSpeed: weatherItem.wind.windSpeed)
                forecastArray.append(forecastWeatherStruct)
            }
        }
        return forecastArray
    }
}
