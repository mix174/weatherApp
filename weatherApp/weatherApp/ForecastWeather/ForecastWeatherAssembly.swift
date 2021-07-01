//
//  ForecastWeatherAssembly.swift
//  weatherApp
//
//  Created by Mix174 on 25.06.2021.
//

import UIKit

final class ForecastWeatherAssembly {
    
    private let forecastWeatherModel: ForecastWeatherModel
    
    init(forecastWeatherModel: ForecastWeatherModel) {
        self.forecastWeatherModel = forecastWeatherModel
    }
    //    Метод для создания вьюКонтроллера и соединения с презентером и моделью
    func build() -> UIViewController {
        let presenter = ForecastWeatherPresenter(
            forecastWeatherModel: forecastWeatherModel)
//        Присвоение вьюконтролера к вью в сториБорде
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: String(describing: ForecastWeatherViewController.self)) as ForecastWeatherViewController
        
        viewController.presenter = presenter
        presenter.forecastView = viewController
        
        return viewController
    }
}
