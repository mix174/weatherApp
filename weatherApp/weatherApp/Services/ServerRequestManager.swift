//
//  ServerRequestManager.swift
//  weatherApp
//
//  Created by Mix174 on 24.06.2021.
//

import Alamofire


final class SereverManager {
//    Singleton
    static let shared = SereverManager()
    
//    Yagni
    weak var currentPresenter: CurrentWeatherPresenterProtocol?

    
    // URL и параметры
    let token = "45edc494a20ba962104df229852f3058"
    let currentUrl = "https://api.openweathermap.org/data/2.5/weather"
    let forecastUrl = "https://api.openweathermap.org/data/2.5/forecast"
    let unitsMetric = "metric"
    
//    Запрос и передача текущей погоды
    func getCurrentWeather(coords: Coordinates, completionHandler: @escaping (CurrentWeatherDecoded) -> Void) {
//        Параметры для URL
        let params = ["lat": coords.latitude,
                      "lon": coords.longitude,
                      "units": unitsMetric,
                      "appid": token] as [String : Any]
        
//        Решить вопрос с self
        AF.request(currentUrl,
                   method: .get,
                   parameters: params)
            .responseJSON { [self] json in
                
                guard json.error == nil,
                      let data = json.data
                else {
                    print("error in JSON in model")
                    return
                }
//                Убрать implicit
                let currentData = try! JSONDecoder().decode(CurrentWeatherDecoded.self, from: data)
                
//                Передача структуры данных в Presentor
                completionHandler(currentData)
            }
    }
//    Запрос и передача прогнозной погоды
    func getForecastWeather(coords: Coordinates, completionHandler: @escaping (ForecastWeatherDecoded) -> Void) {
//        Параметры для URL
        let params = ["lat": coords.latitude,
                      "lon": coords.longitude,
                      "units": unitsMetric,
                      "appid": token] as [String : Any]
        
//        Решить вопрос с self
        AF.request(forecastUrl,
                   method: .get,
                   parameters: params)
            .responseJSON { [self] json in
                
                guard json.error == nil,
                      let data = json.data
                else {
                    print("error in JSON in model")
                    return
                }
//                Убрать implicit
                let forecastData = try! JSONDecoder().decode(ForecastWeatherDecoded.self, from: data)
                
//                Передача структуры данных в Presentor
                completionHandler(forecastData)
            }
    }
//    Запрос и передача текущей погоды по запросу города/страны
    
//    Запрос и передача прогнозной погоды по запросу города/страны
}
