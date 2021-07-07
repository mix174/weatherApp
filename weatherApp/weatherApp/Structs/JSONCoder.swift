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
        let mainCondition: MainCondition?
        let description: String
        let iconCode: IconCode?

        enum CodingKeys: String, CodingKey {
            case mainCondition = "main"
            case description
            case iconCode = "icon"
        }
        
        // Список состояний для mainCondition
        enum MainCondition: String, Codable {
            case clear = "Clear"
            case clouds = "Clouds"
            case rain = "Rain"
            case snow = "Snow"
            case drizzle = "Drizzle"
            case thunderstorm = "Thunderstorm"
            case mist = "Mist"
            case smoke = "Smoke"
            case haze = "Haze"
            case dust = "Dust"
            case fog = "Fog"
            case sand = "Sand"
            case ash = "Ash"
            case squall = "Squall"
            case tornado = "Tornado"
        }
        
        // Список состояний для iconCode
        enum IconCode: String, Codable {
            // Солнечно
            case clearSkyDay = "01d"
            case clearSkyNight = "01n"
            // Преимущественно солнечно
            case fewCloudsDay = "02d"
            case fewCloudsNight = "02n"
            // Облачно
            case scatteredCloudsDay = "03d"
            case scatteredCloudsNight = "03n"
            // Преимущественно облачно
            case brokenCloudsDay = "04d"
            case brokenCloudsNight = "04n"
            // Дождь
            case rainDay = "10d"
            case rainNight = "10n"
            // Ливень
            case showerRainDay = "09d"
            case showerRainNight = "09n"
            // Гроза
            case thunderstormDay = "11d"
            case thunderstormNight = "11n"
            // Снег
            case snowDay = "13d"
            case snowNight = "13n"
            // Туман
            case mistDay = "50d"
            case mistNight = "50n"
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

// дополнительное свойство для извлечения картинки для фона
// в дальнейшем нужно дополнить свойством для извлечения иконки погоды
extension CurrentWeatherDecodable.Weather {
    // Computed Property структуры Weather, для извлечения картинки для фона во вьюКонтроллере
    // Доделать, когда будут доступны картинки
    var backgroundImage: UIImage? {
        switch mainCondition {
        case .clear:
            return UIImage(named: "BG-GoodWeather")
        case .clouds:
            return UIImage(named: "BG-BadWeather")
        case .rain:
            return UIImage(named: "BG-NormalWeather")
        case .snow:
            return UIImage(named: "BG-NormalWeather")
        case .drizzle:
            return UIImage(named: "BG-NormalWeather")
        case .thunderstorm:
            return UIImage(named: "BG-NormalWeather")
        case .mist:
            return UIImage(named: "BG-NormalWeather")
        case .smoke:
            return UIImage(named: "BG-NormalWeather")
        case .haze:
            return UIImage(named: "BG-NormalWeather")
        case .dust:
            return UIImage(named: "BG-NormalWeather")
        case .fog:
            return UIImage(named: "BG-NormalWeather")
        case .sand:
            return UIImage(named: "BG-NormalWeather")
        case .ash:
            return UIImage(named: "BG-NormalWeather")
        case .squall:
            return UIImage(named: "BG-NormalWeather")
        case .tornado:
            return UIImage(named: "BG-NormalWeather")
            // свитч просит case .none, так как mainCondition optinal (?)
        case .none:
            return UIImage(named: "BG-NormalWeather")
        }
    }
    // Computed Property структуры Weather, для извлечения картинки для иконки во вьюКонтроллере
    // Доделать, когда будут доступны иконки
    var iconImage: UIImage? {
        switch iconCode {
        // Солнечно
        case .clearSkyDay:
            return UIImage(named: "")
        case .clearSkyNight:
            return UIImage(named: "")
        // Преимущественно солнечно
        case .fewCloudsDay:
            return UIImage(named: "")
        case .fewCloudsNight:
            return UIImage(named: "")
        // Облачно
        case .scatteredCloudsDay:
            return UIImage(named: "")
        case .scatteredCloudsNight:
            return UIImage(named: "")
        // Преимущественно облачно
        case .brokenCloudsDay:
            return UIImage(named: "")
        case .brokenCloudsNight:
            return UIImage(named: "")
        // Дождь
        case .rainDay:
            return UIImage(named: "")
        case .rainNight:
            return UIImage(named: "")
        // Ливень
        case .showerRainDay:
            return UIImage(named: "")
        case .showerRainNight:
            return UIImage(named: "")
        // Гроза
        case .thunderstormDay:
            return UIImage(named: "")
        case .thunderstormNight:
            return UIImage(named: "")
        // Снег
        case .snowDay:
            return UIImage(named: "")
        case .snowNight:
            return UIImage(named: "")
        // Туман
        case .mistDay:
            return UIImage(named: "")
        case .mistNight:
            return UIImage(named: "")
        // свитч просит case .none, так как iconCode optinal (?)
        case .none:
            return UIImage(named: "")
        }
    }
}
