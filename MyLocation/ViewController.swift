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
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.addSubview(locationButton)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(addPin(press:)))
        longPressRecognizer.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(longPressRecognizer)
        
        locationButton.addTarget(self,
                                 action: #selector(didTapLocationButton),
                                 for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
        locationButton.frame = CGRect(x: mapView.frame.width - 70,
                                      y: mapView.frame.height - 120,
                                      width: 60,
                                      height: 60)
    }
    
    @objc func addPin(press:UIGestureRecognizer) {
        guard press.state == .began else { return }
        print("longPressed")
        
        let touchPoint = press.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let lastAnnotation = self.mapView.annotations[0]
        self.mapView.removeAnnotation(lastAnnotation)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        
        let location = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil,
                  let placemarks = placemarks else {
                      print("Reverse geocoder failed with error" + error!.localizedDescription)
                      return
                  }
            
            if placemarks.count > 0 {
                let pm = placemarks[0]
                
                // not all places have thoroughfare & subThoroughfare so validate those values
                annotation.title = pm.thoroughfare ?? "" //+ ", " //+ pm.subThoroughfare ?? ""
                annotation.subtitle = pm.subLocality
                self.mapView.addAnnotation(annotation)
                print(pm)
            }
            else {
                annotation.title = "Unknown Place"
                self.mapView.addAnnotation(annotation)
                print("Problem with the data received from geocoder")
            }
            
        }
        
    }
    
    
    @objc func didTapLocationButton() {
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

