//
//  LocationManager.swift
//  weatherApp
//
//  Created by Mix174 on 24.06.2021.
//

import CoreLocation

// можно ли без ObservableObject?
final class Locator: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // Singleton
    static let shared = Locator()
    // Connection with Core LocationManager
    private var locationManager = CLLocationManager()
    
//    Yagni
    weak var currentPresenter: CurrentWeatherPresenterProtocol?
    
//    YAGNI ?? Cвойство хранения последней полученной локации
    var lastKnownLocation: Coordinates?
    
    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.last, currentLocation.horizontalAccuracy > 0  else { return }
        
        // // YAGNI ?? прекратить отслеживания для экономии заряда
        manager.stopUpdatingLocation()
        
        let coords = Coordinates(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        
        // YAGNI ??
        print("coords: \(coords)")
        self.lastKnownLocation = coords
        
        currentPresenter?.currentLocationUpdated(coords: coords)
    }
//    YAGNI?
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//            if status == .authorizedWhenInUse {
//                manager.startUpdatingLocation()
//            }
//        }
}
