//
//  CurrentWeatherAssembly.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import UIKit

final class CurrentWeatherAssembly {
    
    private let сurrentWeatherModel = CurrentWeatherModel()
    private let cityModel = CityModel()
    private let serverManager = ServerManager()
    private let locator = Locator()
    
//    Метод для создания вьюКонтроллера и соединения с презентером и моделью
    func build() -> UIViewController {
        let presenter = CurrentWeatherPresenter(
            currentWeatherModel: сurrentWeatherModel,
            cityModel: cityModel,
            serverManager: serverManager,
            locator: locator)
        
//        Присвоение вьюконтролера к вью в сториБорде
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: String(describing: CurrentWeatherViewController.self)) as CurrentWeatherViewController
        // Здесь ли его создавать? Можно сделать через инит
        
        let searchResultController = SearchResultController()
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        
        viewController.presenter = presenter
        presenter.currentView = viewController
        
        searchResultController.presenter = presenter
        presenter.searchResultController = searchResultController
        
        viewController.searchController = searchController
        searchResultController.searchController = searchController
        
        return viewController
    }
}
