//
//  CurrentWeatherViewController.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import UIKit

protocol CurrentWeatherViewControllerProtocol: class {
    func showLoader()
}

final class CurrentWeatherViewController: UIViewController, CurrentWeatherViewControllerProtocol {
    
    var presenter: CurrentWeatherPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    
    func showLoader() {
        print("Показан лоадер")
    }
    
}
