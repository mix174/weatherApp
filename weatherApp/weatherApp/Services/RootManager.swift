//
//  RootController.swift
//  weatherApp
//
//  Created by Mix174 on 29.06.2021.
//

import UIKit

final class RootManager {
    // Singleton
    static let shared = RootManager()
    
//    Хранеие вьюКонтроллеров
    weak private var currentVCroot: UIViewController?
    weak private var forecastVCroot: UIViewController?
    
//    Метод инициализации экрана с текущей погодой, который срабатывает сразу после загрузки приложения
    func start(window: UIWindow) {
        
        let openWeatherModel = OpenWeatherModel()
        let serverManager = ServerManager.shared
        let locator = Locator.shared
        let module = CurrentWeatherAssembly(openWeatherModel: openWeatherModel,
                                            serverManager: serverManager,
                                            locator: locator)
        let currentVC = module.build()
        self.currentVCroot = currentVC
        window.rootViewController = currentVC
        }
//     Метод с перемещением на экран с прогнозной погодой
    func moveToForecastView() {
        let forecastWeatherModel = ForecastWeatherModel()
        let module = ForecastWeatherAssembly(forecastWeatherModel: forecastWeatherModel)
        let newVC = module.build()
        self.forecastVCroot = newVC
        self.currentVCroot?.present(newVC, animated: true, completion: nil)
    }
//    Метод с перемещением на экран с текущей погодой
    func moveToCurrentView() {
        print("moveToCurrentView in Root Manager")
        forecastVCroot?.dismiss(animated: true, completion: nil)
        forecastVCroot = nil // Также надо удалить все аутлеты на вью тд
    }
    
}
