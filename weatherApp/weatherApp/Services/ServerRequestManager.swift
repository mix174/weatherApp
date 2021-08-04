//
//  ServerRequestManager.swift
//  weatherApp
//
//  Created by Mix174 on 24.06.2021.
//

import Alamofire

final class ServerManager {
    
    // MARK: URL'ы и параметры
    // Бесплатный статичный json-список городов (10969 городов внутри)
    private let cityListUrl = "https://raw.githubusercontent.com/aZolo77/citiesBase/master/cities.json"
    // Платный сервис: список городов + возможность находить город по первым буквам
    private let cityOverlapUrl = "https://htmlweb.ru/geo/api.php?json&city_name=%D0%BB&api_key=a7b70091d6d453405b5da7e091f4a281"
    
    // OpenWeatherMap: URL и параметры
    private let token = "45edc494a20ba962104df229852f3058"
    private let currentUrl = "https://api.openweathermap.org/data/2.5/weather"
    private let forecastUrl = "https://api.openweathermap.org/data/2.5/forecast"
    private let unitsMetric = "metric"
    private let langRus = "ru"
    
    // MARK: Определение ошибок с JSON
    // Enum c ошибками для запросов о погоде с сервера, обработки JSON и конвертации JSON в Decodable
    private enum ServerErrorList: Error {
        case jsonError
        case dataNil
    }
    
    // MARK: Функции запросов на сервер
    // Запрос и передача текущей погоды
    func getCurrentWeatherFor(coords: Coordinates,
                           completion: @escaping (Result<CurrentWeatherDecodable, Error>) -> Void) {
        // Параметры для URL
        let params = ["lat": coords.latitude,
                      "lon": coords.longitude,
                      "units": unitsMetric,
                      "lang": langRus,
                      "appid": token] as [String : Any]
        
        AF.request(currentUrl,
                   method: .get,
                   parameters: params)
            .responseJSON { json in
                // проверка ответа с сервера
                guard json.error == nil else {
                    print("error in JSON: \(String(describing: json.error?.errorDescription))")
                    completion(.failure(ServerErrorList.jsonError))
                    return
                }
                // проверка данных в JSON
                guard let data = json.data else {
                    print("json.data is nil")
                    completion(.failure(ServerErrorList.dataNil))
                    return
                }
                // Конвертация данных из JSON в Decodable
                do {
                    let currentWeather = try JSONDecoder().decode(CurrentWeatherDecodable.self, from: data)
                    completion(.success(currentWeather)) // передача currentData в completion
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    // Запрос и передача прогнозной погоды
    func getForecastWeatherFor(coords: Coordinates,
                            completion: @escaping (Result<ForecastWeatherDecodable, Error>) -> Void) {
        // Параметры для URL
        let params = ["lat": coords.latitude,
                      "lon": coords.longitude,
                      "units": unitsMetric,
                      "lang": langRus,
                      "appid": token] as [String : Any]
        
        AF.request(forecastUrl,
                   method: .get,
                   parameters: params)
            .responseJSON { json in
                // Проверка ответа с сервера
                guard json.error == nil else {
                    completion(.failure(ServerErrorList.jsonError))
                    return
                }
                // Проверка данных в JSON
                guard let data = json.data else {
                    completion(.failure(ServerErrorList.dataNil))
                    return
                }
                // Конвертация данных из JSON в Decodable
                do {
                    let forecastWeather = try JSONDecoder().decode(ForecastWeatherDecodable.self, from: data)
                    completion(.success(forecastWeather)) // передача foracastWeather в completion
                } catch {
                    completion(.failure(error))
                }
            }
    }

    // Запрос и передача текущей погоды по запросу города/страны
    func getCurrentWeatherFor(city: String,
                           completion: @escaping (Result<CurrentWeatherDecodable, Error>) -> Void) {
        // Параметры для URL
        let params = ["q": city,
                      "units": unitsMetric,
                      "lang": langRus,
                      "appid": token] as [String : Any]
        
        AF.request(currentUrl,
                   method: .get,
                   parameters: params)
            .responseJSON { json in
                // проверка ответа с сервера
                guard json.error == nil else {
                    print("error in JSON: \(String(describing: json.error?.errorDescription))")
                    completion(.failure(ServerErrorList.jsonError))
                    return
                }
                // проверка данных в JSON
                guard let data = json.data else {
                    print("json.data is nil")
                    completion(.failure(ServerErrorList.dataNil))
                    return
                }
                // Конвертация данных из JSON в Decodable
                do {
                    let currentWeather = try JSONDecoder().decode(CurrentWeatherDecodable.self, from: data)
                    completion(.success(currentWeather)) // передача currentData в completion
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    // Запрос и передача прогнозной погоды по запросу города/страны
    func getForecastWeatherFor(city: String,
                            completion: @escaping (Result<ForecastWeatherDecodable, Error>) -> Void) {
        // Параметры для URL
        let params = ["q": city,
                      "units": unitsMetric,
                      "lang": langRus,
                      "appid": token] as [String : Any]
        
        AF.request(forecastUrl,
                   method: .get,
                   parameters: params)
            .responseJSON { json in
                // Проверка ответа с сервера
                guard json.error == nil else {
                    completion(.failure(ServerErrorList.jsonError))
                    return
                }
                // Проверка данных в JSON
                guard let data = json.data else {
                    completion(.failure(ServerErrorList.dataNil))
                    return
                }
                // Конвертация данных из JSON в Decodable
                do {
                    let forecastWeather = try JSONDecoder().decode(ForecastWeatherDecodable.self, from: data)
                    completion(.success(forecastWeather)) // передача foracastWeather в completion
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    // Запрос на получение простого списка городов
    func getCities(completion:
                    @escaping (Result<CityDecoder, Error>) -> Void) {
        
        AF.request(cityListUrl,
                   method: .get)
            .responseJSON { json in
                // Проверка ответа с сервера
                guard json.error == nil else {
                    completion(.failure(ServerErrorList.jsonError))
                    return
                }
                // Проверка данных в JSON
                guard let data = json.data else {
                    completion(.failure(ServerErrorList.dataNil))
                    return
                }
                // Конвертация данных из JSON в Decodable
                do {
                    let cityMass = try JSONDecoder().decode(CityDecoder.self, from: data)
                    completion(.success(cityMass)) // передача cityMass в completion
                } catch {
                    completion(.failure(error))
                }
            }
    }
}
