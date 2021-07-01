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
    
    init(forecastWeatherModel: ForecastWeatherModel) {
        self.forecastWeatherModel = forecastWeatherModel
    }

//    Загрузка экрана с прогнозной погодой
    func viewDidLoad() {
        print("Презентер-Forecast загрузился")
    }
//    Перемещение на экран с текущей погодой
    func moveToCurrentView() {
        print("moveToCur in presenter")
        RootManager.shared.moveToCurrentView()
    }
}


