//
//  DataManager.swift
//  weatherApp
//
//  Created by Mix174 on 02.07.2021.
//

final class DataManager {
    // Singleton
    static let shared = DataManager()
    
    //Хранение данных
    var forecastWeather: ForecastWeatherDecodable?
}
