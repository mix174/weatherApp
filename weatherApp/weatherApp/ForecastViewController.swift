//
//  ForecastViewController.swift
//  weatherApp
//
//  Created by Mix174 on 24.05.2021.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import CoreLocation


class ForecastViewController: UIViewController {
    
    // Head Labels
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    // ForecastCard1 labels
    @IBOutlet weak var imageLabel1: UIImageView!
    @IBOutlet weak var tempLabel1: UILabel!
    @IBOutlet weak var timeLabel1: UILabel!
    
    // ForecastCard2 labels
    @IBOutlet weak var imageLabel2: UIImageView!
    @IBOutlet weak var tempLabel2: UILabel!
    @IBOutlet weak var timeLabel2: UILabel!
    
    // ForecastCard3 labels
    @IBOutlet weak var imageLabel3: UIImageView!
    @IBOutlet weak var tempLabel3: UILabel!
    @IBOutlet weak var timeLabel3: UILabel!
    
    // ForecastCard4 labels
    @IBOutlet weak var imageLabel4: UIImageView!
    @IBOutlet weak var tempLabel4: UILabel!
    @IBOutlet weak var timeLabel4: UILabel!
    
    // Singletons
    let openWeather = OpenWeatherMap.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(openWeather.forecastCardArray[0].textTimeFormatted)
        print(openWeather.forecastCardArray[0].tempFormatted)
        
        // Setting labels of location
        self.cityNameLabel.text = openWeather.cityName
        self.countryNameLabel.text = openWeather.countryName
     
        // Getting an array of ForecastCard Struct with values in it
        let forecastDataArray = openWeather.forecastCardArray
        
        // Making Dicts (collections) of Card Outlets
        let OutletDict1: [String: AnyObject] = ["pic": imageLabel1,
                                                "temp": tempLabel1,
                                                "time": timeLabel1]
        let OutletDict2: [String: AnyObject] = ["pic": imageLabel2,
                                                "temp": tempLabel2,
                                                "time": timeLabel2]
        let OutletDict3: [String: AnyObject] = ["pic": imageLabel3,
                                                "temp": tempLabel3,
                                                "time": timeLabel3]
        let OutletDict4: [String: AnyObject] = ["pic": imageLabel4,
                                                "temp": tempLabel4,
                                                "time": timeLabel4]
        
        // Making an array of Dicts of Card Outlets
        let OutletDictArray = [OutletDict1, OutletDict2, OutletDict3, OutletDict4]
        
        // Setting forecast cards values through iterator
        for (num, dict) in OutletDictArray.enumerated() {
            for (key, val) in dict {
                //print("i: \(i),x: \(x), y: \(y)")
                
                switch key {
                case "pic":
                    if let imageLabel = val as? UIImageView {
                        imageLabel.image = forecastDataArray[num].iconImage
                    }
                case "temp":
                    if let tempLabel = val as? UILabel {
                        tempLabel.text = forecastDataArray[num].tempFormatted
                    }
                case "time":
                    if let timeLabel = val as? UILabel {
                        timeLabel.text = forecastDataArray[num].textTimeFormatted
                    }
                default:
                    break
                }
            }
        }
    }
}
