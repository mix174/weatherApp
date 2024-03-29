//
//  CurrentWeatherPresenter.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import UIKit

// MARK: Протоколы
// class inhiritance has been deprtiated -> AnyObject
protocol CurrentPresenterProtocol: AnyObject {
    func viewDidLoad()
    // Сервисы
    func getSearchBarAnchor() -> CGFloat?
    func getLocation()
    func getCities()
    func getWeatherFor(city: String)
    // Навигация
    func moveToForecastView()
}

final class CurrentWeatherPresenter: CurrentPresenterProtocol {
    // MARK: Связи
    // Связь с Вью
    weak var currentView: CurrentWeatherViewControllerProtocol?
    var searchResultController: SearchResultControllerProtocol? // weak со стороны searchResultController (иначе убегает)
    // Связь с сервисами
    private let weatherModel: CurrentWeatherModel
    private let cityModel: CityModel
    private let serverManager: ServerManager
    private let locator: Locator
    
    // MARK: Инит
    init(currentWeatherModel: CurrentWeatherModel,
         cityModel: CityModel,
         serverManager: ServerManager,
         locator: Locator) {
        self.weatherModel = currentWeatherModel
        self.cityModel = cityModel
        self.serverManager = serverManager
        self.locator = locator
    }
    
    // MARK: viewDidLoad
    // Загрузка экрана с текущей погодой
    func viewDidLoad() {
        // Показать значок загрузки перед загрузкой данных о локации и погоде
        currentView?.showSpinner()
        // Получить данные о текущей локации
        getLocation()
        
        // Настройка searchController без учета размеров и отступов SearchBarView
        searchResultController?.mainSetup()
    }
    // Передает отступ для таблицы результатов поиска
    func getSearchBarAnchor() -> CGFloat? {
        currentView?.getSearchBarAnchor()
    }
    
    // MARK: Функции локации
    // Запросить данные о текущем местоположении
    func getLocation() {
        locator.getLocation() { [weak self] result in
            // self optinal bindinig
            guard let self = self else { return }
            switch result {
            case .success(let coords):
                print(coords) // Test
                self.getWeatherFor(coords: coords)
            case .failure(let error):
                print("Error at location accured:", error.localizedDescription)
                // спрятать спиннер
                self.currentView?.hideSpinner()
                // Показать пользователю ошибку
                self.currentView?.failureLocation()
            }
        }
    }
    
    // MARK: Функции запроса городов
    // Запрос статичного списка городов
    func getCities() {
        currentView?.showSpinner()
        serverManager.getCities() { [weak self] result in
            // self optinal bindinig
            guard let self = self else { return }
            // Обработка результата
            switch result {
            case .success(let citiesDecodable):
                // конвертация структуры списка городов через модель в простой массив
                let cities = self.cityModel.сitiesSetup(citiesDecodable: citiesDecodable)
                // Передача данных в функцию обновления списка городов
                self.searchResultController?.updateCities(array: cities)
            case .failure(let error):
                print("Error at getCities accured:", error.localizedDescription)
            }
        }
        currentView?.hideSpinner()
    }
    
    // MARK: Функции запроса погодных данных с сервера
    // Загрузка данных с погодой по локации с сервера через ServerRequestManager
    func getWeatherFor(coords: Coordinates) {
        // Подготовка параметров запроса на сервер
        let locationParams = ParamsEncodable(longitude: coords.longitude, latitude: coords.latitude)
        // Получение данных о текущей погоде
        serverManager.getCurrentWeatherFor(location: locationParams) { [weak self] result in
            // self optinal bindinig
            guard let self = self else { return }
            // Обработка результата
            switch result {
            case .success(let currentWeather):
                // конвертация погодных данных через модель
                let currentWeatherStruct = self.weatherModel.weatherStructSetup(currentWeather: currentWeather)
                // Передача данных в функцию обновления экрана
                self.updateOnView(currentWeather: currentWeatherStruct)
            case .failure(let error):
                print("Error at getCurrentWeatherFor(coords) accured:", error.localizedDescription)
            }
        }
        
        // Получение данных о прогнозной погоде
        serverManager.getForecastWeatherFor(location: locationParams) { [weak self] result in
            // self optinal bindinig
            guard let self = self else { return }
            // Обработка результата
            switch result {
            case .success(let forecastWeather):
                // Передача данных в DataManager для экрана с прогнозом
                DataManager.shared.forecastWeather = forecastWeather // можно отложить
                // конвертация погодных данных через модель
                let forecastWeatherStruct = self.weatherModel.weatherStructSetup(forecastWeather: forecastWeather)
                // Передача данных в функцию обновления экрана
                self.updateOnView(forecastWeather: forecastWeatherStruct)
            case .failure(let error):
                print("Error at getForecastWeatherFor(coords) accured:", error.localizedDescription)
            }
        }
    }
    
    // Загрузка данных с погодой по выбранному городу с сервера через ServerRequestManager
    func getWeatherFor(city: String) {
        // Подготовка параметров запроса на сервер
        let cityParams = ParamsEncodable(city: city)
        // Получение данных о текущей погоде
        serverManager.getCurrentWeatherFor(city: cityParams){ [weak self] result in
            // self optinal bindinig
            guard let self = self else { return }
            // Обработка результата
            switch result {
            case .success(let currentWeather):
                // конвертация погодных данных через модель
                let currentWeatherStruct = self.weatherModel.weatherStructSetup(currentWeather: currentWeather)
                // Передача данных в функцию обновления экрана
                self.updateOnView(currentWeather: currentWeatherStruct)
            case .failure(let error):
                print("Error at getCurrentWeatherFor(city) accured:", error.localizedDescription)
            }
        }
        
        // Получение данных о прогнозной погоде
        serverManager.getForecastWeatherFor(city: cityParams) { [weak self] result in
            // self optinal bindinig
            guard let self = self else { return }
            // Обработка результата
            switch result {
            case .success(let forecastWeather):
                // Передача данных в DataManager для экрана с прогнозом
                DataManager.shared.forecastWeather = forecastWeather // можно отложить
                // конвертация погодных данных через модель
                let forecastWeatherStruct = self.weatherModel.weatherStructSetup(forecastWeather: forecastWeather)
                // Передача данных в функцию обновления экрана
                self.updateOnView(forecastWeather: forecastWeatherStruct)
            case .failure(let error):
                print("Error at getForecastWeatherFor(city) accured:", error.localizedDescription)
            }
        }
    }
    
    // MARK: Обновление данных и настройка CurrentView
    // Обновление текущих данных на куррент Вью
    func updateOnView(currentWeather: CurrentWetherStruct) {
        self.currentView?.setWeather(data: currentWeather)
    }
    
    // Обновление прогнозных данных на куррент Вью
    func updateOnView(forecastWeather: [ShortForecastWeatherStruct]) {
        currentView?.updateForecastTable(forecastWeather: forecastWeather)
        self.currentView?.hideSpinner()
    }
    
    // MARK: Навигация
    // Перемещение на экран с прогнозом
    func moveToForecastView() {
        RootManager.shared.moveToForecastView()
    }
}


