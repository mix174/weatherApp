//
//  ServerRequestManager.swift
//  weatherApp
//
//  Created by Mix174 on 24.06.2021.
//

import Alamofire

final class ServerManager {
    
    // MARK: URL'ы
    // Бесплатный статичный json-список городов (10969 городов внутри)
    private let cityListUrl = "https://raw.githubusercontent.com/aZolo77/citiesBase/master/cities.json"
    
    // OpenWeatherMap: URL и параметры
    private let currentUrl = "https://api.openweathermap.org/data/2.5/weather"
    private let forecastUrl = "https://api.openweathermap.org/data/2.5/forecast"
    
    // MARK: Определение ошибок с JSON
    // Enum c ошибками для запросов о погоде с сервера, обработки JSON и конвертации JSON в Decodable
    private enum ServerErrorList: String, Error {
        case jsonError = "Problem with JSON in server request func"
        case dataNil = "Data is nil in server request func"
    }
    
    // MARK: Получение погоды по геолокации
    // Запрос и передача текущей погоды
    func getCurrentWeatherFor(location params: ParamsEncodable,
                           completion: @escaping (Result<CurrentWeatherDecodable, Error>) -> Void) {
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
    func getForecastWeatherFor(location params: ParamsEncodable,
                            completion: @escaping (Result<ForecastWeatherDecodable, Error>) -> Void) {
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
    
    // MARK: Получение погоды по городу
    // Запрос и передача текущей погоды по запросу города/поселка
    func getCurrentWeatherFor(city params: ParamsEncodable,
                           completion: @escaping (Result<CurrentWeatherDecodable, Error>) -> Void) {
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
    func getForecastWeatherFor(city params: ParamsEncodable,
                            completion: @escaping (Result<ForecastWeatherDecodable, Error>) -> Void) {
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
    
    // MARK: Получение списка городов
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
