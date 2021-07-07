//
//  DataManager.swift
//  weatherApp
//
//  Created by Mix174 on 02.07.2021.
//

import Foundation

final class DataManager {
    // Singleton
    static let shared = DataManager()
    
    //Хранение данных
    var forecastData: ForecastDataDecodable?
}
