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



class ViewController: UIViewController, OpenWeatherMapDelegate, CLLocationManagerDelegate {
    
    // New Outlets
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var countryNameLabel: UILabel!
    
    @IBOutlet weak var weatherIconImage: UIImageView!
    
    @IBOutlet weak var currentTempLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    
    /* Old Outlets
    // icon of the weather
    @IBOutlet weak var iconImage: UIImageView!
    
    // choice of the city
    @IBAction func cityButton(_ sender: UIBarButtonItem) {
        
        displayCity()
    }

    // current temp at main scrren
    @IBOutlet weak var currentTemp: UILabel!
    
    // chosen city on the screen
    @IBOutlet weak var cityName: UILabel!
    */
    
    // Singletons
    var openWeather = OpenWeatherMap.shared
    var hud = MBProgressHUD()
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Delegate with openWeather Class
        self.openWeather.delegate = self
        
        // ref's with location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Background setting
        //let bg = UIImage(named: "")
        //self.view.backgroundColor = UIColor(patternImage: bg!)
    }
    
    
    func displayCity() {
        
        let alert = UIAlertController(title: "City", message: "Choose your city", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
            if let textField = alert.textFields?.first {
                self.loadingIndicator()
                self.openWeather.getWeatherFor(textField.text!)
            }
        }
        
        alert.addAction(ok)
        
        alert.addTextField { (textField) -> Void in
            textField.placeholder = "City name"
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadingIndicator() {
        
        hud.label.text = "Loading..."
        hud.areDefaultMotionEffectsEnabled = true
        self.view.addSubview(hud)
        hud.show(animated: true)
    }
    
    //MARK: OpenWeatherMapDelegate
    
    func updateWeatherInfo(weatherJSON: JSON) {
        
        hud.hide(animated: true)
        
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
        
        // for Cheking
        print(openWeather.cityName ?? "city is not initialized")
        print(openWeather.cityTemp ?? "temp is not initialized")
    }
    
    func failure() {
        let failureJsonController = UIAlertController(title: "Trouble Trouble", message: "whatafuck mathafuka suka bliat", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        failureJsonController.addAction(okButton)
        
        hud.hide(animated: true)
        
        self.present(failureJsonController, animated: true, completion: nil)
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location ?? "Location is updated, but something wrong with data")
        
        self.loadingIndicator()
        guard let currentLocation = locations.last else { return }
        
        if currentLocation.horizontalAccuracy > 0 {
            // stop updating for saving battery
            locationManager.stopUpdatingLocation()
            
            let coords = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            self.openWeather.getWeatherFor(coords)
            
            print("coords: \(coords)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("There is an error with loc-manager: \(error)")
    }   
}

