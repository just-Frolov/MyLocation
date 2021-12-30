//
//  LocationManager.swift
//  MyLocation
//
//  Created by Данил Фролов on 23.12.2021.
//

import Foundation
import CoreLocation

protocol CustomLocationManagerDelegate: AnyObject {
    func didUpdateLocation(_ location: CLLocation)
}

class CustomLocationManager: NSObject, CLLocationManagerDelegate {
    //MARK: - Static Constants -
    static let shared = CustomLocationManager()

    //MARK: - Variables -
    private var locationManager = CLLocationManager()
    weak var delegate: CustomLocationManagerDelegate?

    //MARK: - Life Cycle -
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.distanceFilter = 50
    }
    
    //MARK: - Internal -
    func startTracking() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            delegate?.didUpdateLocation(currentLocation)
        }
    }
}
