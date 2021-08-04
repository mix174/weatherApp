//
//  Weather.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import UIKit

struct CurrentWeatherDecodable: Codable {
    // Корневая структура JSON-ответа с сервера (weather)
    let cityId: Int?
    let city: String?
    let weather: Weather
    let main: Main
    let wind: WindSpeed
    let clouds: Clouds
    let timeZone: Double?
    let sys: Sys
    
    private let timeUnix: Double
    let time: String
    let date: String
    let weekday: String
    
    enum CodingKeys: String, CodingKey {
        case cityId = "id"
        case city = "name"
        case weather
        case main
        case wind
        case clouds
        case timeUnix = "dt"
        case timeZone = "timezone"
        case sys
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        cityId = try? container.decode(Int.self, forKey: .cityId)
        city = try? container.decode(String.self, forKey: .city)
        main = try container.decode(Main.self, forKey: .main)
        wind = try container.decode(WindSpeed.self, forKey: .wind)
        clouds = try container.decode(Clouds.self, forKey: .clouds)
        timeZone = try? container.decode(Double.self, forKey: .timeZone)
        sys = try container.decode(Sys.self, forKey: .sys)
        
        let weather = try container.decode([Weather].self, forKey: .weather)
        let timeUnix = try container.decode(Double.self, forKey: .timeUnix)
        self.weather = weather[0]
        self.timeUnix = timeUnix
        
        // time, date & weekday property setup
        // Смотрится криво. Ниже в файле, в extension, есть реализация через computed properties
        let dateFull = Date(timeIntervalSince1970: timeUnix)
        let dateFormatter = DateFormatter()
        // time
        dateFormatter.dateFormat = "HH:mm"
        self.time = dateFormatter.string(from: dateFull)
        // date
        dateFormatter.dateFormat = "dd.MM"
        self.date = dateFormatter.string(from: dateFull)
        // weekday
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "EEEE"
        self.weekday = dateFormatter.string(from: dateFull).capitalized
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
            case clear = "Clear",
                 clouds = "Clouds",
                 rain = "Rain",
                 snow = "Snow",
                 drizzle = "Drizzle",
                 thunderstorm = "Thunderstorm",
                 mist = "Mist",
                 smoke = "Smoke",
                 haze = "Haze",
                 dust = "Dust",
                 fog = "Fog",
                 sand = "Sand",
                 ash = "Ash",
                 squall = "Squall",
                 tornado = "Tornado"
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
        let temp: String
        let feelsLike: String
        let pressure: String
        let humidity: String
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case pressure
            case humidity
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let temp = try container.decode(Double.self, forKey: .temp)
            let feelsLike = try container.decode(Double.self, forKey: .feelsLike)
            let pressure = try container.decode(Double.self, forKey: .pressure)
            let humidity = try container.decode(Double.self, forKey: .humidity)
            
            self.temp = "\(Int(temp.rounded()))°"
            self.feelsLike = "\(Int(feelsLike.rounded()))°"
            self.pressure = "\(Int((pressure / 1000 * 750.064).rounded())) ммрт"
            self.humidity = "\(Int(humidity.rounded()))%"
        }
    }
    // Вложенная структура Wind
    struct WindSpeed: Codable {
        let windSpeed: String
        
        enum CodingKeys: String, CodingKey {
            case windSpeed = "speed"
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let windSpeed = try container.decode(Double.self, forKey: .windSpeed)
            self.windSpeed = "\(Int(windSpeed.rounded())) м/с"
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
        let timeZone: Double
        
        enum CodingKeys: String, CodingKey {
            case cityId = "id"
            case city = "name"
            case country
            case timeZone = "timezone"
        }
    }
}

// дополнение для извлечения картинки фона и иконки
extension CurrentWeatherDecodable.Weather {
    // Computed Property структуры Weather, для извлечения картинки для фона на вьюКонтроллере
    var backgroundImage: UIImage? {
        switch mainCondition {
        case .clear:
            return UIImage(named: "BG-peach")
        case .clouds:
            return UIImage(named: "BG-lightBlue")
        case .rain:
            return UIImage(named: "BG-lightBlue")
        case .snow:
            return UIImage(named: "BG-grey")
        case .drizzle:
            return UIImage(named: "BG-grey")
        case .thunderstorm:
            return UIImage(named: "BG-grey")
        case .mist:
            return UIImage(named: "BG-grey")
        case .smoke:
            return UIImage(named: "BG-grey")
        case .haze:
            return UIImage(named: "BG-grey")
        case .dust:
            return UIImage(named: "BG-grey")
        case .fog:
            return UIImage(named: "BG-grey")
        case .sand:
            return UIImage(named: "BG-grey")
        case .ash:
            return UIImage(named: "BG-grey")
        case .squall:
            return UIImage(named: "BG-grey")
        case .tornado:
            return UIImage(named: "BG-grey")
        // картинка при отсутствии
        case .none:
            return UIImage(named: "BG-NormalWeather")
        }
    }
    // Computed Property структуры Weather, для извлечения картинки для иконки во вьюКонтроллере
    // Доделать, когда будут доступны все иконки
    var iconImage: UIImage? {
        switch iconCode {
        // Солнечно
        case .clearSkyDay:
            return UIImage(named: "clearSkyDay")
        case .clearSkyNight:
            return UIImage(named: "clearSkyDay")
        // Преимущественно солнечно
        case .fewCloudsDay:
            return UIImage(named: "fewCloudsDay")
        case .fewCloudsNight:
            return UIImage(named: "fewCloudsDay")
        // Облачно
        case .scatteredCloudsDay:
            return UIImage(named: "scatteredCloudsDay")
        case .scatteredCloudsNight:
            return UIImage(named: "scatteredCloudsDay")
        // Преимущественно облачно
        case .brokenCloudsDay:
            return UIImage(named: "brokenCloudsDay")
        case .brokenCloudsNight:
            return UIImage(named: "brokenCloudsDay")
        // Дождь
        case .rainDay:
            return UIImage(named: "rainDay")
        case .rainNight:
            return UIImage(named: "rainDay")
        // Ливень
        case .showerRainDay:
            return UIImage(named: "showerRainDay")
        case .showerRainNight:
            return UIImage(named: "showerRainDay")
        // Гроза
        case .thunderstormDay:
            return UIImage(named: "thunderstormDay")
        case .thunderstormNight:
            return UIImage(named: "thunderstormDay")
        // Снег
        case .snowDay:
            return UIImage(named: "none")
        case .snowNight:
            return UIImage(named: "none")
        // Туман
        case .mistDay:
            return UIImage(named: "none")
        case .mistNight:
            return UIImage(named: "none")
        // картинка при отсутствии
        case .none:
            return UIImage(named: "none")
        }
    }
}

// YAGNI??
// Дополнение корневой структуры CurrentWeatherDecodable для работы с отображением времени и дня недели
extension CurrentWeatherDecodable {
    // Используется Unix время: не понятно, нужно ли добавлять timeShift (сдвиг часового пояса)? так как если его добавлять, то появляются лишние 3 часа, а без него все как надо (есть подозрение, что ошибка в другом, но мб и нет). Изначально было сделано в ForecastWeatherDecodable, чтобы использовать timeZone. Сейчас сделано без timeZone, поэтому проще реализовать в CurrentWeatherDecodable
    var timeNew: String {
        let dateFull = Date(timeIntervalSince1970: timeUnix)
        let dateFormatter = DateFormatter()
        
        print("timeView: ", dateFull) // test

        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: dateFull)
        return time
    }
    var dateNew: String {
        let dateFull = Date(timeIntervalSince1970: timeUnix)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        let date = dateFormatter.string(from: dateFull)
        return date
    }
    var weekdayNew: String {
        let dateFull = Date(timeIntervalSince1970: timeUnix)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: dateFull).capitalized
        return day
    }
}
