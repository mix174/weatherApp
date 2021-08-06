//
//  CurrentWeatherPresenter.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import UIKit

// MARK: Протоколы
protocol CurrentWeatherPresenterProtocol: class {
    func viewDidLoad()
    // Сервисы
    func getLocation()
    func getCityArray()
    func getWeatherFor(city: String)
    // Вью
    func setOnView(searchBar: UISearchBar)
    func setOnView(resultTable: ResultTableView)
    // Навигация
    func moveToForecastView()
}

final class CurrentWeatherPresenter: CurrentWeatherPresenterProtocol {
    // MARK: Связи
    // Связь с Вью
    weak var currentView: CurrentWeatherViewControllerProtocol?
    var searchViewController: SearchViewControllerProtocol? // weak со стороны searchViewController (иначе убегает) | сервис это или Вью?) (по факту, вью, но выполняет функции сервиса и функции вью)
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
        // Настройка searchController
        searchViewController?.mainSetup()
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
    
    // MARK: Функции запроса списка городов
    // Запрос статичного списка городов
    func getCityArray() {
        currentView?.showSpinner()
        serverManager.getCities() { [weak self] result in
            // self optinal bindinig
            guard let self = self else { return }
            // Обработка результата
            switch result {
            case .success(let cityStruct):
                // конвертация структуры списка городов через модель в простой массив
                let cityArray = self.cityModel.сitiesSetup(citiesDecodable: cityStruct)
                // Передача данных в функцию обновления списка городов
                self.searchViewController?.updateCity(array: cityArray)
                // Открытие resultTable после загрузки и обработки
                self.searchViewController?.showResultTable()
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
                print("Error at getForecastWeatherFor(coords) accured:", error.localizedDescription)
            }
        }
    }
    
    // MARK: Обновление данных и настройка CurrentView
    // Добавление searchBar на currentView
    func setOnView(searchBar: UISearchBar) {
        currentView?.setOnView(searchBar: searchBar)
    }
    
    // Добавление resultTable на currentView
    func setOnView(resultTable: ResultTableView) {
        currentView?.setOnView(resultTable: resultTable)
    }
    
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


