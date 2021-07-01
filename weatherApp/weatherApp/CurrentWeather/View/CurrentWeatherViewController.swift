//
//  CurrentWeatherViewController.swift
//  weatherApp
//
//  Created by Mix174 on 04.06.2021.
//

import Foundation
import UIKit
import MBProgressHUD

protocol CurrentWeatherViewControllerProtocol: class {
    func showSpinner()
    func hideSpinner()
}

final class CurrentWeatherViewController: UIViewController, CurrentWeatherViewControllerProtocol {
    
    // Delegates
    var presenter: CurrentWeatherPresenterProtocol?
    
    // Navigation Buttoms
    @IBAction func toForecastViewButtom(_ sender: UIButton) {
        print("show Forecast buttom entered")
        self.presenter?.moveToForecastView()
    }
    
    // Loading spinner init in property
    var spinner = MBProgressHUD(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    
    // Main action
    override func viewDidLoad() {
        super.viewDidLoad()
        print("куррент-вью загрузился")
        presenter?.viewDidLoad()
        
        view.backgroundColor = UIColor.red
        
    }
    
    // Funcs for spinner
    func showSpinner() {
        spinner.areDefaultMotionEffectsEnabled = true
        self.view.addSubview(spinner)
        spinner.show(animated: true)
        print("spinner показан")
    }
    func hideSpinner() {
        spinner.hide(animated: true)
        spinner.removeFromSuperview()
        print("spinner спрятан")
        print(self.view.subviews)
    }
    
}
