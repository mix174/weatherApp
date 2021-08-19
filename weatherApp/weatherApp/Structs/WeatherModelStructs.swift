//
//  WeatherModelStructs.swift
//  weatherApp
//
//  Created by Mix174 on 26.07.2021.
//

import UIKit

// MARK: Структура для основных данных на экране с текущей погодой
struct CurrentWetherStruct {
    let locationDraft: String
    var location: String {
        if locationDraft == "" {
            return "На странных берегах" // отсылка
        } else {
            return locationDraft
        }
    }
    let descriptionDraft: String
    var description: String {
        let string = descriptionDraft
        let startIndex = string.startIndex
        
        return string.replacingCharacters(in: startIndex...startIndex, with: String(string[startIndex]).capitalized)
    }
    let icon: UIImage
    let temp: String
    let tempBlank: String
    let humidity: String
    let windSpeed: String
    let backgroundImage: UIImage
}

// MARK: Структура для прогнозных данных на экране с текущей погодой
struct ShortForecastWeatherStruct {
    let time: String
    let icon: UIImage
    let temp: String
}

// MARK: Структура для прогнозных данных на экране с прогнозной погодой
struct LongForecastWeatherStruct {
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
