//
//  LocationManager.swift
//  weatherApp
//
//  Created by Mix174 on 24.06.2021.
//

import CoreLocation

protocol LocatorDelegate {
    func getCurrentLocation(_ completion: @escaping (_ coords: Coordinates) -> Void)
}

// можно ли без ObservableObject? - да, можно
final class Locator: NSObject, CLLocationManagerDelegate, LocatorDelegate {
    
    // Singleton
    static let shared = Locator()
    // Connection with Core LocationManager
    private var locationManager = CLLocationManager()
    
    // Хранение completion для requestLocation
    private var completionHandler: ((_ coords: Coordinates) -> Void)?
    
    
    func getCurrentLocation(_ completion: @escaping (_ coords: Coordinates) -> Void) {
        // костыль проверки на установленность Locator в качестве делегата для CLLocationManager
        if locationManager.delegate == nil {
            locationManager.delegate = self
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // настройка точности определения локации
        // все, что выше в данной функции, нужно перенести в отдельное место (init)
        
        completionHandler = completion // сохранение completion
        locationManager.requestWhenInUseAuthorization() // запрос на права на отслеживание локации
        locationManager.requestLocation() // запрос на локацию
    }
    
//    MARK: CLLocationManagerDelegate funcs
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // optinal binding крайнего значение локации + проверка на точность
        guard let currentLocation = locations.last, currentLocation.horizontalAccuracy > 0  else {
            self.locationManager.requestLocation() // повторный запрос на локацию, если условие в guard не соблюдено
            return
        }
        
        let coords = Coordinates(latitude: currentLocation.coordinate.latitude,
                                 longitude: currentLocation.coordinate.longitude) // Конвертация полученной локации в структуру Coordinates
        // передача локации в completion и его "запуск"
        completionHandler?(coords)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("CLLocationManager did Fail With Error: \(error)")
    }
//    YAGNI?
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//            if status == .authorizedWhenInUse {
//                manager.startUpdatingLocation()
//            }
//        }
}
