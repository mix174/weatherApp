//
//  CurrentWeatherPresenter.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import Foundation

protocol CurrentWeatherPresenterProtocol {
    func viewDidLoad()
}

final class CurrentWeatherPresenter: CurrentWeatherPresenterProtocol {
    
    weak var view: CurrentWeatherViewControllerProtocol?
    private let openWeatherMap: OpenWeatherMap
    
    init(openWeatherMap: OpenWeatherMap) {
        self.openWeatherMap = openWeatherMap
    }
    
    func viewDidLoad() {
        print("Презентер загрузился")
        
        print("Данные загружены")
        
        view?.showLoader()
        openWeatherMap.getWeatherFor("Moscow")
    }
}


