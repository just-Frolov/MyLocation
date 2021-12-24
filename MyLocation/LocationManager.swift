//
//  LocationManager.swift
//  MyLocation
//
//  Created by Данил Фролов on 23.12.2021.
//

import Foundation
import MapKit

protocol CustomLocationManagerDelegate: AnyObject {
    func customLocationManager(didUpdate locations: [CLLocation])
}

class CustomLocationManager: NSObject, CLLocationManagerDelegate {
    //MARK: - Private Constants -
    static let shared = CustomLocationManager()

    //MARK: - Variables -
    private var locationManager = CLLocationManager()
    weak var delegate: CustomLocationManagerDelegate?

    //MARK: - Life Cycle -
    private override init()
    {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //MARK: - Internal -
    func startTracking()
    {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.customLocationManager(didUpdate: locations)
    }
}
