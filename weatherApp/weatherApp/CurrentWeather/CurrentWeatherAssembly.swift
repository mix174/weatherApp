//
//  CurrentWeatherAssembly.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import UIKit

final class CurrentWeatherAssembly {
    
    private let openWeatherMap: OpenWeatherMap
    
    init(openWeatherMap: OpenWeatherMap) {
        self.openWeatherMap = openWeatherMap
    }
    
    func build() -> UIViewController {
        let presenter = CurrentWeatherPresenter(openWeatherMap: openWeatherMap)
        let viewController = CurrentWeatherViewController()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        return viewController
    }
}
