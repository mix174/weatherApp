//
//  CurrentWeatherAssembly.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import UIKit

final class CurrentWeatherAssembly {
    
    private let сurrentDataModel = CurrentDataModel()
    private let serverManager = ServerManager()
    private let locator = Locator()
    
//    Метод для создания вьюКонтроллера и соединения с презентером и моделью
    func build() -> UIViewController {
        let presenter = CurrentWeatherPresenter(
            currentDataModel: сurrentDataModel,
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
