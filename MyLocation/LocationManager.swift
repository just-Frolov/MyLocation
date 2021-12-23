//
//  LocationManager.swift
//  MyLocation
//
//  Created by Данил Фролов on 23.12.2021.
//

import Foundation
import CoreLocation

/*
 
 */
class LocationManager {
    var currentLocation: CLLocation? {
        didSet {
            if oldValue == nil && currentLocation != nil {
                
            }
        }
    }
    
    private func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //battery
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

class UserPresenter {
    var shared = UserPresenter()
    
    
    
}
