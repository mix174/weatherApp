//
//  ServerRequestManager.swift
//  weatherApp
//
//  Created by Mix174 on 24.06.2021.
//

import Alamofire


final class ServerManager {
    
    // URL и параметры
    let token = "45edc494a20ba962104df229852f3058"
    let currentUrl = "https://api.openweathermap.org/data/2.5/weather"
    let forecastUrl = "https://api.openweathermap.org/data/2.5/forecast"
    let unitsMetric = "metric"
    
    // Enum c ошибками для запросов о погоде с сервера, обработки JSON и конвертации JSON в Decodable
    enum ServerErrorList: Error {
        case jsonError
        case dataNil
    }
    
    // Запрос и передача текущей погоды
    func getCurrentWeather(coords: Coordinates,
                           completion: @escaping (Result<CurrentWeatherDecodable, Error>) -> Void) {
        // Параметры для URL
        let params = ["lat": coords.latitude,
                      "lon": coords.longitude,
                      "units": unitsMetric,
                      "appid": token] as [String : Any]
        
        AF.request(currentUrl,
                   method: .get,
                   parameters: params)
            .responseJSON { json in // self ни на что не ссылался, поэтому был удален
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
    func getForecastWeather(coords: Coordinates,
                            completion: @escaping (Result<ForecastWeatherDecodable, Error>) -> Void) {
        // Параметры для URL
        let params = ["lat": coords.latitude,
                      "lon": coords.longitude,
                      "units": unitsMetric,
                      "appid": token] as [String : Any]
        
        AF.request(forecastUrl,
                   method: .get,
                   parameters: params)
            .responseJSON { json in // self ни на что не ссылался, поэтому был удален
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
    
    // Запрос и передача прогнозной погоды по запросу города/страны
}
