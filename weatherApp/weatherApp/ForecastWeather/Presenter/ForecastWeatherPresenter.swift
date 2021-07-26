//
//  ForecastWeatherPresenter.swift
//  weatherApp
//
//  Created by Mix174 on 25.06.2021.
//

protocol ForecastWeatherPresenterProtocol: class {
    func viewDidLoad()
    func moveToCurrentView()
}

final class ForecastWeatherPresenter: ForecastWeatherPresenterProtocol {
    
    // Связь с сервисами
    weak var forecastView: ForecastWeatherViewControllerProtocol?
    private let weatherModel: ForecastWeatherModel
    private let dataManager = DataManager.shared
    
    // Инициализатор
    init(forecastDataModel: ForecastWeatherModel) {
        self.weatherModel = forecastDataModel
    }

    // Загрузка экрана с прогнозной погодой
    func viewDidLoad() {
        print("Презентер-Forecast загрузился")
        forecastView?.showSpinner()
        guard let forecastWather = dataManager.forecastWeather else {
            print("no forecast weather at forecast-presenter")
            return }
        weatherModelSetup(forecastWeather: forecastWather)
    }
    
    func weatherModelSetup(forecastWeather: ForecastWeatherDecodable) {
        let weatherArray = weatherModel.weatherStructSetup(forecastWeather: forecastWeather)
        updateWeatherView(weatherArray: weatherArray)
    }
    
    func updateWeatherView(weatherArray: [ForecastWeatherStruct]) {
        forecastView?.updateWeather(weatherArray: weatherArray)
    }
    
    // Перемещение на экран с текущей погодой
    func moveToCurrentView() {
        print("moveToCur in presenter")
        RootManager.shared.moveToCurrentView()
    }
}


