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
    
    func moveToForecastView()
}

final class CurrentWeatherPresenter: CurrentWeatherPresenterProtocol {
    
    // Связь с сервисами
    weak var currentView: CurrentWeatherViewControllerProtocol?
    private let openWeatherModel: OpenWeatherModel
    private let serverManager: ServerManager
    private let locator: LocatorDelegate?
    
    init(openWeatherModel: OpenWeatherModel,
         serverManager: ServerManager,
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
        locator?.getCurrentLocation() { coords in
            print(coords)
            self.getServerWeatherData(coords: coords)
        }
        
        // Передать данные в вью
        
        
        // Спрятать значок загрузки после загрузки данных с текущей погодой с сервера
    }
    
    
    // Загрузить данные с текущей погодой с сервера через ServerRequestManager
    func getServerWeatherData(coords: Coordinates) {
        serverManager.getCurrentWeather(coords: coords) { result in
            print("Current Data: updated")
            
            switch result {
            case .success(let currentData):
                self.updateCurrentDataOnView(currentData: currentData)
            case .failure(let error):
                print("Error at current accured:", error.localizedDescription)
            }
            
        }
        serverManager.getForecastWeather(coords: coords) { result in
            print("Forecast Data: updated")
            
            switch result {
            case .success(let forecastData):
                DataManager.shared.forecastData = forecastData // можно отложить
                self.updateForecastDataOnView(forecastData: forecastData)
            case .failure(let error):
                print("Error at forecast accured:", error.localizedDescription)
            }
        }
    }
    
    // Обновление Вью
    func updateCurrentDataOnView(currentData: CurrentWeatherDecodable) {
        print("Функция обновления данных в презентере на вью")
        print("current windSpeed: ", currentData.wind.windSpeed)
        self.currentView?.hideSpinner()
//            self.currentView?.setBackground(backgroundImage: currentData.weather[0].backgroundImage)
//            self.currentView?.setBackground(imageName: currentData.weather[0].backgroundImageName)

    }
    func updateForecastDataOnView(forecastData: ForecastWeatherDecodable) {
        print("Функция обновления данных в презентере на вью")
        print("forecast temp: ", forecastData.partWeather[3].main.temp)
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


