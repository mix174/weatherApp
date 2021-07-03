//
//  CurrentWeatherAssembly.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import UIKit

final class CurrentWeatherAssembly {
    
    private let openWeatherModel: OpenWeatherModel
    private let serverManager: ServerManager
    private let locator: Locator
    
    init(openWeatherModel: OpenWeatherModel,
         serverManager: ServerManager,
         locator: Locator) {
        self.openWeatherModel = openWeatherModel
        self.serverManager = serverManager
        self.locator = locator
    }
//    Метод для создания вьюКонтроллера и соединения с презентером и моделью
    func build() -> UIViewController {
        let presenter = CurrentWeatherPresenter(
            openWeatherModel: openWeatherModel,
            serverManager: serverManager,
            locator: locator)
        
//        Присвоение вьюконтролера к вью в сториБорде
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: String(describing: CurrentWeatherViewController.self)) as CurrentWeatherViewController
        
        viewController.presenter = presenter
        presenter.currentView = viewController
        
        return viewController
    }
}
