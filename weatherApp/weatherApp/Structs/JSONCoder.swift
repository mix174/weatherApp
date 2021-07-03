//
//  Weather.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import Foundation
import UIKit

struct CurrentWeatherDecodable: Codable {
    // Корневая структура JSON-ответа с сервера (weather)
    let cityId: Int?
    let city: String?
    let weather: [Weather]
    let main: Main
    let wind: WindSpeed
    let clouds: Clouds
    let time: Int
    let sys: Sys
    
    enum CodingKeys: String, CodingKey {
        case cityId = "id"
        case city = "name"
        case weather
        case main
        case wind
        case clouds
        case time = "dt"
        case sys
    }
    // Вложенная структура Weather
    struct Weather: Codable {
        let mainCondition: String
        let description: String
        let iconCode: String

        enum CodingKeys: String, CodingKey {
            case mainCondition = "main"
            case description
            case iconCode = "icon"
        }
    }
    // Вложенная структура Main
    struct Main: Codable {
        let temp: Double
        let feelsLike: Double
        let pressure: Double
        let humidity: Double
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case pressure
            case humidity
        }
    }
    // Вложенная структура Wind
    struct WindSpeed: Codable {
        let windSpeed: Double
        
        enum CodingKeys: String, CodingKey {
            case windSpeed = "speed"
        }
    }
    // Вложенная структура Clouds
    struct Clouds: Codable {
        let clouds: Double
        
        enum CodingKeys: String, CodingKey {
            case clouds = "all"
        }
    }
    // Вложенная структура Sys
    struct Sys: Codable {
        let country: String?
        
        enum CodingKeys: String, CodingKey {
            case country
        }
    }
}

struct ForecastWeatherDecodable: Codable {
    // Корневая структура JSON-ответа с сервера (forecast)
    
    // Вложенная структура list (массив прогнозных значений с разницей в 3 часа, в массиве 40 значений).
    // Структура декодируется с помощью структуры для основной погоды так как все значения совпадают, за искл. country в Sys.
    let partWeather: [CurrentWeatherDecodable]
    let cityForecast: CityForecast
    
    enum CodingKeys: String, CodingKey {
        case partWeather = "list"
        case cityForecast = "city"
    }
    // Вложенная структура City
    struct CityForecast: Codable {
        let cityId: Int
        let city: String
        let country: String
        
        enum CodingKeys: String, CodingKey {
            case cityId = "id"
            case city = "name"
            case country
        }
    }
}

// сделать энум для определения погоды (extension Wheather.WheatherType {} var backgroundColor: UIcolor {})
// Сделал свитч, который определяет картинку
// Сделать свитч, который преобразует в название картинки, чтобы вьюКонтроллер сам вытаскивал картинку по названию, чтобы структура не тоскала картинку за собой?
extension CurrentWeatherDecodable.Weather {
    
    enum MainCondition: String {
        case clear = "Clear"
        case clouds = "Clouds"
    }
    
    // Computed Property структуры Weather, для извлечения картинки во вьюКонтроллере
    var backgroundImage: UIImage! {
        
        switch mainCondition {
        case MainCondition.clear.rawValue :
            return UIImage(named: "BG-GoodWeather")
        case MainCondition.clouds.rawValue :
            return UIImage(named: "BG-BadWeather")
        default:
            return UIImage(named: "BG-NormalWeather")
        }
    }
    // // Computed Property структуры Weather, для извлечения названия картинки во вьюКонтроллере
    var backgroundImageName: String {
        switch mainCondition {
        case "Clear":
            return "BG-GoodWeather"
        case "Clouds":
            return "BG-BadWeather"
        default:
            return "BG-NormalWeather"
        }
    }
}
