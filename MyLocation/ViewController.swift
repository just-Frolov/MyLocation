//
//  ViewController.swift
//  MyLocation
//
//  Created by Данил Фролов on 20.12.2021.
//

import CoreLocationUI
import MapKit
import UIKit

class ViewController: UIViewController {
    private let mapView = MKMapView()
    
    private let locationButton: CLLocationButton  = {
        let button = CLLocationButton()
        button.icon = .arrowOutline
        button.cornerRadius = 12
        return button
    }()
    
    private let addPinButton: UIButton  = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.setTitle("Add Pin", for: .normal)
        return button
    }()
    
    private let deletePinButton: UIButton  = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 12
        button.setTitle("Del Pin", for: .normal)
        return button
    }()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.addSubview(locationButton)
        mapView.addSubview(addPinButton)
        mapView.addSubview(deletePinButton)
        
        locationButton.addTarget(self,
                                 action: #selector(didTapLocationButton),
                                 for: .touchUpInside)
        addPinButton.addTarget(self,
                                 action: #selector(didTapAddPinButton),
                                 for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
        locationButton.frame = CGRect(x: mapView.safeAreaInsets.left + 20,
                              y: mapView.safeAreaInsets.top + 20,
                              width: 60,
                              height: 60)
        addPinButton.frame = CGRect(x: view.frame.width - 90,
                                      y: mapView.safeAreaInsets.top + 20,
                                      width: 70,
                                      height: 60)
        deletePinButton.frame = CGRect(x: view.frame.width - 180,
                                       y: mapView.safeAreaInsets.top + 20,
                                       width: 70,
                                       height: 60)
    }

    @objc func didTapLocationButton() {
        locationManager.startUpdatingLocation()
    }
    
    @objc func didTapAddPinButton() {
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupManager()
    }
    
    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //battery
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate  else { return }
        self.locationManager.stopUpdatingLocation()
        let region = MKCoordinateRegion(center: location,
                                        latitudinalMeters: 5000,
                                        longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
}

