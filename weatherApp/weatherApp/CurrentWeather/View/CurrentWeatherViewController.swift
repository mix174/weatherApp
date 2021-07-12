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
    func setBackground(backgroundImage: UIImage)
    func failureLocation()
}

final class CurrentWeatherViewController: UIViewController, CurrentWeatherViewControllerProtocol {
    
    // Delegates
    var presenter: CurrentWeatherPresenterProtocol?
    
    // Navigation Buttoms
    @IBAction func moveToForecastView(_ sender: UIButton) {
        print("forecastButton pressed")
        self.presenter?.moveToForecastView()
    }
    
    // Spinner check - временная проверка
    @IBAction func spinnerCheck(_ sender: UIButton) {
        showSpinner()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            showSpinner()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [self] in
            hideSpinner()
        }
    }
    
    // Loading spinner init in property
    let spinner = MBProgressHUD(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    // Main action
    override func viewDidLoad() {
        super.viewDidLoad()
        print("куррент-вью загрузился")
        presenter?.viewDidLoad()
        
    }
    // Background Setup — нужно сделать выбор между методом
    func setBackground(backgroundImage: UIImage) {

        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = backgroundImage
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }

    // Funcs for spinner
    func showSpinner() {
        guard spinner.alpha == 0 else {
            print("spinner is alredy showed")
            return
        }
        spinner.areDefaultMotionEffectsEnabled = true
        self.view.addSubview(spinner)
        spinner.show(animated: true)
        print("spinner показан")
    }
    func hideSpinner() {
        spinner.hide(animated: true)
        spinner.removeFromSuperview()
        print("spinner спрятан")
    }
    
    // Функция отображения ошибки (требует доработки)
    func failureLocation() {
        let failureController = UIAlertController(title: "Ошибка", message: "Проблема с локацией", preferredStyle: .alert)
        
        let tryAgain = UIAlertAction(title: "Перезапустить локацию", style: .default) { [weak self] _ in
            self?.presenter?.getLocation()
        }
        let showHomeCity = UIAlertAction(title: "Показать домашний регион", style: .default) { [weak self] _ in
            // требует доработки
            self?.presenter?.getWeatherFor(city: "Moscow")
        }
        
        failureController.addAction(tryAgain)
        failureController.addAction(showHomeCity)
        
        self.present(failureController, animated: true, completion: nil)
    }
}
