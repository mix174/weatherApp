//
//  WeatherModelStructs.swift
//  weatherApp
//
//  Created by Mix174 on 26.07.2021.
//

import UIKit

// Структура для основных данных на экране с текущей погодой
struct CurrentWetherStruct {
    let location: String
    let description: String
    let icon: UIImage
    let temp: String
    let humidity: String
    let windSpeed: String
    let backgroundImage: UIImage
}
// Структура для прогнозных данных на экране с текущей погодой
struct TableViewWeatherStruct {
    let time: String
    let icon: UIImage
    let temp: String
}
// Структура для прогнозных данных на экране с прогнозной погодой
struct ForecastWeatherStruct {
    let time: String
    let date: String
    let weekday: String
    let location: String
    let icon: UIImage
    let temp: String
    let humidity: String
    let windSpeed: String
    let backgroundImage: UIImage
}
