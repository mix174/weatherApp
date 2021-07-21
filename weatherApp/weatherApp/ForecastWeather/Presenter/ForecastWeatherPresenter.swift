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
    private let forecastWeatherModel: ForecastWeatherModel
    private var dataManager = DataManager.shared
    
    // Инициализатор
    init(forecastDataModel: ForecastWeatherModel) {
        self.forecastWeatherModel = forecastDataModel
    }

    // Загрузка экрана с прогнозной погодой
    func viewDidLoad() {
        print("Презентер-Forecast загрузился")
        guard let forecastWather = dataManager.forecastWeather else {
            print("no forecast weather at forecast-presenter")
            return }
        prepareWeatherModel(data: forecastWather)
    }
    
    func prepareWeatherModel(data: ForecastWeatherDecodable) {
        let weatherArray = forecastWeatherModel.prepareWeatherModel(data: data)
        updateWeatherView(weatherArray: weatherArray)
    }
    
    func updateWeatherView(weatherArray: [CurrentWeatherDecodable]) {
        forecastView?.updateWeather(weatherArray: weatherArray)
    }
    
    // Перемещение на экран с текущей погодой
    func moveToCurrentView() {
        print("moveToCur in presenter")
        RootManager.shared.moveToCurrentView()
    }
}


