//
//  Weather.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import Foundation

struct CurrentWeatherDecoded: Codable {
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
        case weather = "weather"
        case main = "main"
        case wind = "wind"
        case clouds = "clouds"
        case time = "dt"
        case sys = "sys"
    }
    // Вложенная структура Weather
    struct Weather: Codable {
        let main: String
        let description: String
        let iconCode: String

        enum CodingKeys: String, CodingKey {
            case main = "main"
            case description = "description"
            case iconCode = "icon"
        }
        
        // сделать энум для определения погоды (extension Wheather.WheatherType {} var backgroundColor: UIcolor {})
    }
    // Вложенная структура Main
    struct Main: Codable {
        let temp: Double
        let feelsLike: Double
        let pressure: Double
        let humidity: Double
        
        enum CodingKeys: String, CodingKey {
            case temp = "temp"
            case feelsLike = "feels_like"
            case pressure = "pressure"
            case humidity = "humidity"
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
            case country = "country"
        }
    }
}

struct ForecastWeatherDecoded: Codable {
    // Корневая структура JSON-ответа с сервера (forecast)
    
    // Вложенная структура list (массив прогнозных значений с разницей в 3 часа, в массиве 40 значений).
    // Структура декодируется с помощью структуры для основной погоды так как все значения совпадают, за искл. country в Sys.
    let partWeather: [CurrentWeatherDecoded]
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
            case country = "country"
        }
    }
}
