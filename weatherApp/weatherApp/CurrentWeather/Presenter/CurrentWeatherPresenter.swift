//
//  CurrentWeatherPresenter.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import UIKit

protocol CurrentWeatherPresenterProtocol: class {
    func viewDidLoad()
    
    func getWeatherFor(city: String)
    
    func currentLocationUpdated(coords: Coordinates)
    
    func updateCurrentWeatherOnView(currentWeather: CurrentWeatherDecoded)
    
    func moveToForecastView()
}

final class CurrentWeatherPresenter: CurrentWeatherPresenterProtocol {
    
    // Связь с сервисами
    weak var currentView: CurrentWeatherViewControllerProtocol?
    private let openWeatherModel: OpenWeatherModel
    private let serverManager: SereverManager
    private let locator: Locator
    
    init(openWeatherModel: OpenWeatherModel,
         serverManager: SereverManager,
         locator: Locator) {
        self.openWeatherModel = openWeatherModel
        self.serverManager = serverManager
        self.locator = locator
    }

    
    // Загрузка экрана с текущей погодой
    func viewDidLoad() {
        print("Презентер загрузился")
        
        // Показать значок загрузки перед загрузкой данных о локации и погоде
        currentView?.showSpinner()
        
        // Получить данные о текущей локации
        locator.startUpdatingLocation()
        
        // Передать данные в вью
        
        
        // Спрятать значок загрузки после загрузки данных с текущей погодой с сервера
        
        
    }
    
    // Загрузить данные с текущей погодой с сервера через модель
    func currentLocationUpdated(coords: Coordinates) {
        serverManager.getCurrentWeather(coords: coords) { currentData in
            print("Current Data: updated")
        }
        serverManager.getForecastWeather(coords: coords) { forecastData in
            print("Forecast Data: updated")
        }
        currentView?.hideSpinner()
    }
    
    // Обновление Вью
    func updateCurrentWeatherOnView(currentWeather: CurrentWeatherDecoded) {
        print("Функция обновления данных в презентере на вью")
        print("windSpeed: ", currentWeather.wind.windSpeed)
    }
    
    
//    Перемещение на экран с прогнозом
    func moveToForecastView() {
        RootManager.shared.moveToForecastView()
    }
    
    
    
    
    
    
    // #Later
    // Получение инфы о погоде в городе по запросу
    func getWeatherFor(city: String) {
    }
    
    
}


