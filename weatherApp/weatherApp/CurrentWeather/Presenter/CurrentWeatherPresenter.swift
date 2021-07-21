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
        // Показать значок загрузки перед загрузкой данных о локации и погоде
        currentView?.showSpinner()
        // Получить данные о текущей локации
        getLocation()
        
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
            // Обработка результата
            switch result {
            case .success(let forecastWeather):
                // Передача данных в DataManager для экрана с прогнозом
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
        // TEST
        print("Функция обновления текущих данных в презентере на вью")
        print(currentWeather.timeUnix)
        
        self.currentView?.setWeather(data: currentWeather)
        self.currentView?.hideSpinner()
    }
    
    // Обновление прогнозных данных на куррент Вью
    func updateOnView(forecastWeather: ForecastWeatherDecodable) {
        // TEST
        print("Функция обновления прогнозных данных в презентере на вью")
        print(forecastWeather.partWeather[0].time)
        print(forecastWeather.partWeather[0].weekday)
        
        currentView?.updateForecastTable(forecastWeather: forecastWeather)
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


