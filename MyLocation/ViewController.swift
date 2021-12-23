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
    //MARK: - UI Elements -
    lazy var locationButton: UIButton  = {
        let button = UIButton()
        let icon = UIImage(systemName: "location")
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self,
                                 action: #selector(didTapLocationButton),
                                 for: .touchUpInside)
        return button
    }()
    
    //MARK: - Private Constants -
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubview()
        addPinRecognizer()
        setLocationButtonConstraints()
        setupManager()
    }
    
    //MARK: - Private -
    private func setSubview() {
        view.addSubview(mapView)
        mapView.addSubview(locationButton)
    }
    
    private func addPinRecognizer() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(addPin(press:)))
        longPressRecognizer.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    private func setLocationButtonConstraints() {
        let sizeLocationButton: CGFloat = 100
        let spaceAtBottomForLocationButton: CGFloat = -60
        let spaceAtRightForLocationButton: CGFloat = -100
        
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationButton.widthAnchor.constraint(equalToConstant: sizeLocationButton),
            locationButton.heightAnchor.constraint(equalToConstant: sizeLocationButton),
            locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: spaceAtBottomForLocationButton),
            locationButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: spaceAtRightForLocationButton)
        ])
    }
    
    private func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //battery
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc private func didTapLocationButton(locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        let region = MKCoordinateRegion(center: location,
                                        latitudinalMeters: 5000,
                                        longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
    }
    
    @objc private func addPin(press: UIGestureRecognizer) {
        guard press.state == .began else { return }
        print("longPressed")
        
        let touchPoint = press.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let lastAnnotations = self.mapView.annotations
        
        for lastAnnotation in lastAnnotations {
                self.mapView.removeAnnotation(lastAnnotation)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        let location = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
        
        setTitleToPin(on: location, for: annotation)
    }
    
    fileprivate func setTitleToPin(on location: CLLocation, for annotation: MKPointAnnotation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let placeMark = placemarks!.first!
                annotation.title = placeMark.thoroughfare ?? "" + ", \(String(describing: placeMark.subThoroughfare))"
                annotation.subtitle = placeMark.subLocality
                self.mapView.addAnnotation(annotation)
            } else {
                annotation.title = "Unknown Place"
                self.mapView.addAnnotation(annotation)
                print("Problem with the data received from geocoder")
            }
        }
    }
}

//MARK: - CLLocation Manager Delegate -
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.showsUserLocation = true
    }
}

