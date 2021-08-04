//
//  ForecastWeatherPresenter.swift
//  weatherApp
//
//  Created by Mix174 on 25.06.2021.
//

// MARK: Протоколы
protocol ForecastWeatherPresenterProtocol: class {
    func viewDidLoad()
}

final class ForecastWeatherPresenter: ForecastWeatherPresenterProtocol {
    // MARK: Связи
    // Связь с Вью
    weak var forecastView: ForecastWeatherViewControllerProtocol?
    // Связь с сервисами
    private let weatherModel: ForecastWeatherModel
    private let dataManager = DataManager.shared
    
    // MARK: Инит
    init(forecastDataModel: ForecastWeatherModel) {
        self.weatherModel = forecastDataModel
    }
    
    // MARK: viewDidLoad
    func viewDidLoad() {
        forecastView?.showSpinner()
        guard let forecastWather = dataManager.forecastWeather else {
            print("no forecast weather at forecast-presenter")
            return }
        weatherModelSetup(forecastWeather: forecastWather)
    }
    
    // MARK: Работа с моделью данных
    // Сборка модели данных
    func weatherModelSetup(forecastWeather: ForecastWeatherDecodable) {
        let weatherArray = weatherModel.weatherStructSetup(forecastWeather: forecastWeather)
        updateWeatherView(weatherArray: weatherArray)
    }
    
    // MARK: Работа с Вью
    // Обновление данных на forecastView
    func updateWeatherView(weatherArray: [LongForecastWeatherStruct]) {
        forecastView?.updateWeather(weatherArray: weatherArray)
    }
}


