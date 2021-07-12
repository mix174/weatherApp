//
//  CurrentWeatherPresenter.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import UIKit

protocol CurrentWeatherPresenterProtocol: class {
    func viewDidLoad()
    func getLocation()
    
    func getWeatherFor(city: String)
    
    func moveToForecastView()
}

final class CurrentWeatherPresenter: CurrentWeatherPresenterProtocol {
    
    // Связь с сервисами
    weak var currentView: CurrentWeatherViewControllerProtocol?
    private let openWeatherModel: CurrentWeatherModel
    private let serverManager: ServerManager
    private let locator: Locator
    
    init(currentWeatherModel: CurrentWeatherModel,
         serverManager: ServerManager,
         locator: Locator) {
        self.openWeatherModel = currentWeatherModel
        self.serverManager = serverManager
        self.locator = locator
    }
    
    // Загрузка экрана с текущей погодой
    func viewDidLoad() {
        print("Презентер загрузился")
        
        // Показать значок загрузки перед загрузкой данных о локации и погоде
        currentView?.showSpinner()
        
        // Получить данные о текущей локации
        getLocation()
        
        // Передать данные в вью
        
        // Спрятать значок загрузки после загрузки данных с текущей погодой с сервера
    }
    // Запросить данные о текущем местоположении
    func getLocation() {
        locator.getLocation() { [weak self] result in
            // self optinal bindinig
            guard let self = self else { return }
            switch result {
            case .success(let coords):
                print(coords)
                self.getServerData(coords: coords)
            case .failure(let error):
                print("Error at location accured:", error.localizedDescription)
                // спрятать спиннер
                self.currentView?.hideSpinner()
                // Показать пользователю ошибку
                self.currentView?.failureLocation()
            }
        }
    }
    
    // Загрузить данные с погодой с сервера через ServerRequestManager
    func getServerData(coords: Coordinates) {
        // Данные о текущей погоде
        serverManager.getCurrentWeather(coords: coords) { [weak self] result in
            // self optinal bindinig
            guard let self = self else { return }
            
            print("Current Data: updated")
            // Обработка результата
            switch result {
            case .success(let currentWeather):
                // Передача данных в функцию обновления экрана
                self.updateOnView(currentWeather: currentWeather)
            case .failure(let error):
                print("Error at currentWeatherData accured:", error.localizedDescription)
            }
        }
        // Данные о пронозной погоде
        serverManager.getForecastWeather(coords: coords) { [weak self] result in
            // self optinal bindinig
            guard let self = self else { return }
            
            print("Forecast Data: updated")
            // Обработка результата
            switch result {
            case .success(let forecastWeather):
                // Передача данных в DataManager для прогнозного экрана
                DataManager.shared.forecastWeather = forecastWeather // можно отложить
                // Передача данных в функцию обновления экрана
                self.updateOnView(forecastWeather: forecastWeather)
            case .failure(let error):
                print("Error at forecast accured:", error.localizedDescription)
            }
        }
    }
    
    // Обновление текущих данных на куррент Вью
    func updateOnView(currentWeather: CurrentWeatherDecodable) {
        print("Функция обновления данных в презентере на вью")
        print("current windSpeed: ", currentWeather.wind.windSpeed)
        print("current main: ", currentWeather.weather[0].mainCondition!)
        self.currentView?.hideSpinner()
        guard let background = currentWeather.weather[0].backgroundImage else { return }
        self.currentView?.setBackground(backgroundImage: background)
    }
    
    // Обновление прогнозных данных на куррент Вью
    func updateOnView(forecastWeather: ForecastWeatherDecodable) {
        print("Функция обновления данных в презентере на вью")
        print("forecast temp: ", forecastWeather.partWeather[3].main.temp)
    }
    
//    Перемещение на экран с прогнозом
    func moveToForecastView() {
        RootManager.shared.moveToForecastView()
    }
    
    // #Later
    // Получение инфы о погоде в городе по запросу
    func getWeatherFor(city: String) {
        print("func of getting weather for \(city) is not ready yet")
    }
    
}


