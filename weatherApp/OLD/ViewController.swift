//
//  ViewController.swift
//  weatherApp
//
//  Created by Mix174 on 17.05.2021.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import CoreLocation

// MARK: !!ЧЕРНОВИК!! (Старый файл)

final class ViewController: UIViewController, OpenWeatherMapDelegate, CLLocationManagerDelegate {
    
    @IBOutlet private weak var cityNameLabel: UILabel!
    
    @IBOutlet private weak var countryNameLabel: UILabel!
    
    @IBOutlet private weak var weatherIconImage: UIImageView!
    
    @IBOutlet private weak var currentTempLabel: UILabel!
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var humidityLabel: UILabel!
    
    @IBOutlet private weak var windSpeedLabel: UILabel!
    
    // Singletons
    var openWeather = OpenWeatherMap.shared
    
    // Services
    var spinner = MBProgressHUD()
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate with openWeatherMap Class
        self.openWeather.delegate = self
        
        // ref's with location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        print("zero first controller loaded")
        
    }
   
    // YAGNI
    func displayCity() {
        
        let alert = UIAlertController(title: "City", message: "Choose your city", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        // Retain cyccle [weak self]
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
            if let textField = alert.textFields?.first {
                self.loadingIndicator()
                self.openWeather.getWeatherFor(textField.text!) // force unwrap
            }
        }
        
        alert.addAction(ok)
        
        alert.addTextField { (textField) -> Void in
            textField.placeholder = "City name"
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadingIndicator() {
        
        spinner.label.text = "Loading..."
        spinner.areDefaultMotionEffectsEnabled = true
        self.view.addSubview(spinner)
        spinner.show(animated: true)
        print(self.view.subviews)
        spinner.hide(animated: true)
        //self.view.subviews.re
        spinner.removeFromSuperview()
    }
    
    //MARK: OpenWeatherMapDelegate
    
    func updateWeatherInfo(weatherJSON: JSON) {
        
        present(by: self)
        
        spinner.hide(animated: true)
        
        
        //Codable
        // Getting values from JSON
        if let name = weatherJSON["name"].string,
           let country = weatherJSON["sys"]["country"].string,
           let iconCode = weatherJSON["weather"][0]["icon"].string,
           let temp = weatherJSON["main"]["temp"].double,
           let description = weatherJSON["weather"][0]["description"].string,
           let humidity = weatherJSON["main"]["humidity"].double,
           let windSpeed = weatherJSON["wind"]["speed"].double
           {
            
            // Setting JSON values for openWeather object
            openWeather.cityName = name
            openWeather.countryName = country
            openWeather.iconCode = iconCode
            openWeather.cityTemp = temp
            openWeather.description = description
            openWeather.humidity = humidity
            openWeather.windSpeed = windSpeed
            
            // Setting view by values from openWeather object
            self.cityNameLabel.text = openWeather.cityName
            self.countryNameLabel.text = openWeather.countryName
            self.weatherIconImage.image = openWeather.icon
            self.currentTempLabel.text = openWeather.cityTempFormatted
            self.descriptionLabel.text = openWeather.description
            self.humidityLabel.text = "\(openWeather.humidity ?? 999) %"
            self.windSpeedLabel.text = "\(openWeather.windSpeed ?? 999) m/s"
        }
    }
    
    func failure() {
        let failureJsonController = UIAlertController(title: "Trouble Trouble", message: "whatafuck mathafuka suka bliat", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        failureJsonController.addAction(okButton)
        
        spinner.hide(animated: true)
        
        self.present(failureJsonController, animated: true, completion: nil)
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(manager.location ?? "Location is updated, but something wrong with data")
        
        self.loadingIndicator()
        guard let currentLocation = locations.last, currentLocation.horizontalAccuracy > 0  else { return }
        
            // stop updating for saving battery
            manager.stopUpdatingLocation()
            
            let coords = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            self.openWeather.getWeatherFor(coords)

    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("There is an error with loc-manager: \(error)")
    }
    
    func present(by vc: UIViewController) {
//        let сurrentDataModel = CurrentDataModel()
//        let serverManager = ServerManager()
//        let locator = Locator()
        let module = CurrentWeatherAssembly()
        
        let newVC = module.build()
        
        vc.present(newVC, animated: true, completion: nil)
    }
}

//// Spinner check - временная проверка
//@IBAction func spinnerCheck(_ sender: UIButton) {
//    showSpinner()
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
//        showSpinner()
//    }
//    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [self] in
//        hideSpinner()
//    }
//}
