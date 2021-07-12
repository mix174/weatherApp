//
//  LocationManager.swift
//  weatherApp
//
//  Created by Mix174 on 24.06.2021.
//

import CoreLocation


// можно ли без ObservableObject? - да, можно
final class Locator: NSObject, CLLocationManagerDelegate {
    
    // Connection with Core LocationManager
    private let locationManager: CLLocationManager
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        // Дополнительная настройка CLLocationManager
        locationManager.delegate = self // назначение объекта данного класса делегатом для CLLocationManager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // настройка точности определения локации
    }
    // Enum c ошибками
    enum LocationErrorList: Error {
        case horizontalAccurError
    }
    // Хранение completion для requestLocation
    private var completionHandler: ((Result<Coordinates, Error>) -> Void)?
    
    func getLocation(_ completion: @escaping (Result<Coordinates, Error>) -> Void) {
        
        completionHandler = completion // сохранение completion
        locationManager.requestWhenInUseAuthorization() // запрос на права на отслеживание локации
        locationManager.requestLocation() // запрос на локацию
    }
    
//    MARK: CLLocationManagerDelegate funcs
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // optinal binding крайнего значение локации + проверка на точность
        guard let currentLocation = locations.last, currentLocation.horizontalAccuracy > 0  else {
            completionHandler?(.failure(LocationErrorList.horizontalAccurError))
            return
        }
        
        let coords = Coordinates(latitude: currentLocation.coordinate.latitude,
                                 longitude: currentLocation.coordinate.longitude) // Конвертация полученной локации в структуру Coordinates
        // передача локации в completion и его "запуск"
        completionHandler?(.success(coords))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completionHandler?(.failure(error))
    }
//    YAGNI?
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//            if status == .authorizedWhenInUse {
//                manager.startUpdatingLocation()
//            }
//        }
}
