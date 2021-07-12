//
//  OpenWeatherMap.swift
//  weatherApp
//
//  Created by Mix174 on 17.05.2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

// MARK: !!ЧЕРНОВИК!! (Старый файл)

protocol OpenWeatherMapDelegate {
    func updateWeatherInfo(weatherJSON: JSON)
    func failure()
}

class OpenWeatherMap {
    // OpenWeatherMap Singleton init
    static var shared = OpenWeatherMap()
    
    var delegate: OpenWeatherMapDelegate!
    
    // Nested type for working with forecast cards
    // !May be implemented out of OpenWeatherMap Class!
    struct ForecastCard {
        var dtTime: Int
        var temp: Double
        var tempFormatted: String {
            OpenWeatherMap.shared.converterTemp(country: OpenWeatherMap.shared.countryName ?? "default",
                                                temp: temp)
        }
        var iconCode: String
        var iconImage: UIImage {
            OpenWeatherMap.shared.weatherIcon(iconCode: iconCode)
        }
        var textTime: String
        var textTimeFormatted: String {
            let result = textTime[textTime.index(textTime.startIndex, offsetBy: 11)...textTime.index(textTime.startIndex, offsetBy: 15)]
            return String(result)
        }
    }
    
    // Properties of a model
    var forecastCardArray: [ForecastCard] = []
    
    let url = "https://api.openweathermap.org/data/2.5/weather"
    let urlForecast = "https://api.openweathermap.org/data/2.5/forecast"
    let apiKey = "45edc494a20ba962104df229852f3058"
    //let urlComplete = "https://api.openweathermap.org/data/2.5/weather?q=Moscow&units=metric&appid=45edc494a20ba962104df229852f3058"
    
    // needs for additions after
    //also needs to check up converting func (what if request with not the metric unit?)
    let unit = "metric"
    
    // Properties from JSON
    var cityName: String?
    var countryName: String?
    var cityTemp: Double?
    var cityTempFormatted: String {
        converterTemp(country: countryName ?? "default", temp: cityTemp ?? 999)
    }
    
    var description: String?
    var iconCode: String?
    var icon: UIImage {
        weatherIcon(iconCode: iconCode ?? "none")
    }
    var humidity: Double?
    var windSpeed: Double?
    
    // Fuctions
    func getWeatherFor(_ city: String) {
        
        let params = ["q": city,
                      "units": unit,
                      "appid": apiKey]
        setRequest(params: params)
    }
    
    func getWeatherFor(_ coords: CLLocationCoordinate2D) {
        
        let params = ["lat": coords.latitude,
                      "lon": coords.longitude,
                      "units": unit,
                      "appid": apiKey] as [String : Any]
        
        sendRequest(url: url, params: params) { result in
            print(result)
        }
        setRequest(params: params)
    }
    
    func setRequest(params: [String: Any]?) {
        //let dispatchGroup = DispatchGroup()
        
        // Request for current weather
        //dispatchGroup.enter()
        AF.request(url,
                   method: .get,
                   parameters: params)
            .responseJSON { json in
                defer {
                    //dispatchGroup.leave()
                }
                
                guard json.error == nil, let data = json.data else {
                    self.delegate.failure()
                    return
                }
                
                print("data ", data)
            
                let currentJSON = JSON(data)
                
                // cross to main thred
                self.delegate.updateWeatherInfo(weatherJSON: currentJSON)
                print("Current ended")
        }
        
        // Request for forecast weather
        //dispatchGroup.enter()
        AF.request(urlForecast,
                   method: .get,
                   parameters: params)
            .responseJSON { json in
                
                defer {
                    //dispatchGroup.leave()
                }
                
                
                guard json.error == nil else {
                    self.delegate.failure()
                    return
                }
                
                let forecastJSON = JSON(json.data!)
                
                // (JSON data into ForecastCard-Struct format objects) into array iterator
                for i in 1...8 {
                    if let dt = forecastJSON["list"][i]["dt"].int,
                       let temp = forecastJSON["list"][i]["main"]["temp"].double,
                       let iconCode = forecastJSON["list"][i]["weather"][0]["icon"].string,
                       let textTime = forecastJSON["list"][i]["dt_txt"].string {
                        self.forecastCardArray.append(ForecastCard(dtTime: dt, temp: temp, iconCode: iconCode, textTime: textTime))
                    }
                }
                
                //print("Forecast ended")
        }
        
//        dispatchGroup.notify(queue: .main) {
            //print("End")
//        }
        print("setRequest ended")
    }
    
    
    func converterTemp(country: String, temp: Double) -> String {
        
        if country == "US" {
            let newTemp = temp * 9 / 5 + 32
            return String(format: "%.1f", newTemp) + "°F"
        } else {
            return String(format: "%.1f", temp) + "°"
        }
    }
    
    func weatherIcon(iconCode: String) -> UIImage {
        guard let image = UIImage(named: iconCode) else { return UIImage(named: "none")! }
        return image
    }
    
    /*  Review  */
    
    enum ServerError: Error {
        case jsonError
        case dataNil
    }
    
    func sendRequest(
        url: String,
        params: [String: Any],
        completion: @escaping (Result<CurrentWeatherDecodable, Error>) -> Void
    ) {
        AF.request(
            url,
            method: .get,
            parameters: params
        ).responseJSON { json in
            
            guard json.error == nil else {
                completion(.failure(ServerError.jsonError))
                return
            }
            
            guard let data = json.data else {
                completion(.failure(ServerError.dataNil))
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(CurrentWeatherDecodable.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

// старое из LocationManager
// Хранение completion для requestLocation

//private var completionHandler: ((_ coords: Coordinates) -> Void)?
//
//func getLocation(_ completion: @escaping (_ coords: Coordinates) -> Void) {
//
//    completionHandler = completion // сохранение completion
//    locationManager.requestWhenInUseAuthorization() // запрос на права на отслеживание локации
//    locationManager.requestLocation() // запрос на локацию
//}
//
////    MARK: CLLocationManagerDelegate funcs
//func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    // optinal binding крайнего значение локации + проверка на точность
//    guard let currentLocation = locations.last, currentLocation.horizontalAccuracy > 0  else {
//        self.locationManager.requestLocation() // повторный запрос на локацию, если условие в guard не соблюдено
//        return
//    }
//
//    let coords = Coordinates(latitude: currentLocation.coordinate.latitude,
//                             longitude: currentLocation.coordinate.longitude) // Конвертация полученной локации в структуру Coordinates
//    // передача локации в completion и его "запуск"
//    completionHandler?(coords)
//}
//
//func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//    print("CLLocationManager did Fail With Error: \(error)")
//}
