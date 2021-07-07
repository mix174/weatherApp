//
//  Weather.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import Foundation
import UIKit

struct CurrentDataDecodable: Codable {
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
        let mainCondition: MainCondition
        let description: String
        let iconCode: IconCode

        enum CodingKeys: String, CodingKey {
            case mainCondition = "main"
            case description
            case iconCode = "icon"
        }
        // Список состояний для mainCondition
        enum MainCondition: Codable {
            case clear
            case clouds
            case rain
            case snow
            case drizzle
            case thunderstorm
            case mist
            case notSet // по умолчанию при ошибке или аномальном состоянии
            
            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                switch try container.decode(String.self) {
                // clear
                case "Clear" :
                    self = .clear
                // clouds
                case "Clouds" :
                    self = .clouds
                // rain
                case "Rain" :
                    self = .rain
                // snow
                case "Snow" :
                    self = .snow
                // drizzle
                case "Drizzle" :
                    self = .drizzle
                // thunderstorm
                case "Thunderstorm" :
                    self = .thunderstorm
                // Все варианты ниже обладают единым смыслом для mist
                case "Mist" :
                    self = .mist
                case "Smoke" :
                    self = .mist
                case "Haze" :
                    self = .mist
                case "Dust" :
                    self = .mist
                case "Fog" :
                    self = .mist
                case "Sand" :
                    self = .mist
                case "Ash" :
                    self = .mist
                case "Squall" :
                    self = .mist
                case "Tornado" :
                    self = .mist
                default:
                    self = .notSet
                }
            }
            // так как codable = decodable + encodable. мб перейти на decodable?
            // если нет, то дополнить cases
            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .clear :
                    try container.encode("Clear")
                default: fatalError() // Так в рефе, на что поменять?
                }
            }
        }
        // Список состояний для iconCode
        enum IconCode: Codable {
            case clearSky
            case fewClouds
            case scatteredClouds
            case brokenClouds
            case showerRain
            case rain
            case thunderstorm
            case snow
            case mist
            case notSet // по умолчанию при ошибке или аномальном состоянии
            
            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                switch try container.decode(String.self) {
                // clearSky
                case "01d" :
                    self = .clearSky
                case "01n" :
                    self = .clearSky
                // fewClouds
                case "02d" :
                    self = .fewClouds
                case "02n" :
                    self = .fewClouds
                // scatteredClouds
                case "03d" :
                    self = .scatteredClouds
                case "03n" :
                    self = .scatteredClouds
                // brokenClouds
                case "04d" :
                    self = .brokenClouds
                case "04n" :
                    self = .brokenClouds
                // showerRain
                case "09d" :
                    self = .showerRain
                case "09n" :
                    self = .showerRain
                // rain
                case "10d" :
                    self = .rain
                case "10n" :
                    self = .rain
                // thunderstorm
                case "11d" :
                    self = .thunderstorm
                case "11n" :
                    self = .thunderstorm
                // snow
                case "13d" :
                    self = .snow
                case "13n" :
                    self = .snow
                // mist
                case "50d" :
                    self = .mist
                case "50n" :
                    self = .mist
                // notSet
                default :
                    self = .notSet
                }
            }
            // так как codable = decodable + encodable. мб перейти на decodable?
            // если нет, то дополнить cases
            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .clearSky :
                    try container.encode("01d")
                default: fatalError() // Так в рефе, на что поменять?
                }
            }
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

struct ForecastDataDecodable: Codable {
    // Корневая структура JSON-ответа с сервера (forecast)
    
    // Вложенная структура list (массив прогнозных значений с разницей в 3 часа, в массиве 40 значений).
    // Структура декодируется с помощью структуры для основной погоды так как все значения совпадают, за искл. country в Sys.
    let partWeather: [CurrentDataDecodable]
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

// дополнительное свойство для извлечения картинки для фона
// в дальнейшем нужно дополнить свойством для извлечения иконки погоды
extension CurrentDataDecodable.Weather {
    // Computed Property структуры Weather, для извлечения картинки во вьюКонтроллере
    var backgroundImage: UIImage! {
        
        switch mainCondition {
        case .clear :
            return UIImage(named: "BG-GoodWeather")
        case .clouds :
            return UIImage(named: "BG-BadWeather")
        case .rain :
            return UIImage(named: "BG-NormalWeather")
        case .snow :
            return UIImage(named: "BG-NormalWeather")
        case .drizzle :
            return UIImage(named: "BG-NormalWeather")
        case .thunderstorm :
            return UIImage(named: "BG-NormalWeather")
        case .mist :
            return UIImage(named: "BG-NormalWeather")
        case .notSet :
            return UIImage(named: "BG-NormalWeather")
        }
    }
    // Later
    // var backgroundImage: UIImage! {}
}
