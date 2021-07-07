//
//  CurrentWeatherPresenter.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import UIKit

protocol CurrentWeatherPresenterProtocol: class {
    func viewDidLoad()
    
    func getDataFor(city: String)
    
    func moveToForecastView()
}

final class CurrentWeatherPresenter: CurrentWeatherPresenterProtocol {
    
    // Связь с сервисами
    weak var currentView: CurrentWeatherViewControllerProtocol?
    private let openWeatherModel: CurrentDataModel
    private let serverManager: ServerManager
    private let locator: Locator
    
    init(currentDataModel: CurrentDataModel,
         serverManager: ServerManager,
         locator: Locator) {
        self.openWeatherModel = currentDataModel
        self.serverManager = serverManager
        self.locator = locator
    }
    
    // Загрузка экрана с текущей погодой
    func viewDidLoad() {
        print("Презентер загрузился")
        
        // Показать значок загрузки перед загрузкой данных о локации и погоде
        currentView?.showSpinner()

        
        // Получить данные о текущей локации
        locator.getLocation() { coords in
            print(coords)
            self.getServerData(coords: coords)
        }
        
        // Передать данные в вью
        
        // Спрятать значок загрузки после загрузки данных с текущей погодой с сервера
    }
    
    
    // Загрузить данные с текущей погодой с сервера через ServerRequestManager
    func getServerData(coords: Coordinates) {
        serverManager.getCurrentData(coords: coords) { [weak self] result in
            // self optinal bindinig
            guard let self = self else { return }
            
            print("Current Data: updated")
            // Обработка результата
            switch result {
            case .success(let currentData):
                // Передача данных в функцию обновления экрана
                self.updateOnView(currentData: currentData)
            case .failure(let error):
                print("Error at current accured:", error.localizedDescription)
            }
        }
        
        serverManager.getForecastData(coords: coords) { [weak self] result in
            // self optinal bindinig
            guard let self = self else { return }
            
            print("Forecast Data: updated")
            // Обработка результата
            switch result {
            case .success(let forecastData):
                // Передача данных в DataManager для прогнозного экрана
                DataManager.shared.forecastData = forecastData // можно отложить
                // Передача данных в функцию обновления экрана
                self.updateOnView(forecastData: forecastData)
            case .failure(let error):
                print("Error at forecast accured:", error.localizedDescription)
            }
        }
    }
    
    // Обновление Вью
    func updateOnView(currentData: CurrentDataDecodable) {
        print("Функция обновления данных в презентере на вью")
        print("current windSpeed: ", currentData.wind.windSpeed)
        print("current main: ", currentData.weather[0].mainCondition)
        self.currentView?.hideSpinner()
        self.currentView?.setBackground(backgroundImage: currentData.weather[0].backgroundImage)

    }
    func updateOnView(forecastData: ForecastDataDecodable) {
        print("Функция обновления данных в презентере на вью")
        print("forecast temp: ", forecastData.partWeather[3].main.temp)
    }
    
//    Перемещение на экран с прогнозом
    func moveToForecastView() {
        RootManager.shared.moveToForecastView()
    }
    
    
    
    
    
    
    // #Later
    // Получение инфы о погоде в городе по запросу
    func getDataFor(city: String) {
    }
    
    
}


