//
//  ViewController.swift
//  MyLocation
//
//  Created by Данил Фролов on 20.12.2021.
//
import MapKit
import UIKit

class ViewController: UIViewController {
    //MARK: - UI Elements -
    lazy var locationButton: UIButton  = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let icon = UIImage(systemName: "location.fill")
        button.backgroundColor = .white
        button.layer.cornerRadius = button.frame.width/2
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self,
                         action: #selector(didTapLocationButton),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: - Private Constants -
    private let mapView = MKMapView()
    
    //MARK: - Variables -
    private var isFirstLocationUpdate = Bool()
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        isFirstLocationUpdate = true
        
        setSubview()
        setMapViewLocation()
        setLocationButtonConstraints()
        setupManager()
        addPinRecognizer()
    }
    
    //MARK: - Private -
    private func setSubview() {
        self.view = mapView
        view.addSubview(locationButton)
    }
    
    private func setMapViewLocation() {
        mapView.frame = view.bounds
    }
    
    private func setLocationButtonConstraints() {
        let sizeLocationButton: CGFloat = 50
        let spaceAtBottomForLocationButton: CGFloat = -30
        let spaceAtRightForLocationButton: CGFloat = -10
        
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationButton.widthAnchor.constraint(equalToConstant: sizeLocationButton),
            locationButton.heightAnchor.constraint(equalToConstant: sizeLocationButton),
            locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: spaceAtBottomForLocationButton),
            locationButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: spaceAtRightForLocationButton)
        ])
    }
    
    private func addPinRecognizer() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(addPin(press:)))
        longPressRecognizer.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc private func didTapLocationButton() {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate,
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
    
    private func setTitleToPin(on location: CLLocation, for annotation: MKPointAnnotation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            var annotationTitle = String()
            var annotationSubTitle = String()
            let places = placemarks ?? []
            
            if places.count > 0 {
                if let placeMark = places.first {
                    if let street = placeMark.thoroughfare {
                        annotationTitle += street
                    }
                    if let country = placeMark.country {
                        annotationSubTitle += country
                    }
                    
                    if !annotationTitle.isEmpty {
                        annotation.title = annotationTitle
                    } else {
                        //lon lan
                    }
                    
                    if !annotationTitle.isEmpty {
                        annotation.subtitle = annotationSubTitle
                    } else {
                        //lon lan
                    }
                    
                    self.mapView.addAnnotation(annotation)
                }
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
        if isFirstLocationUpdate, let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: 5000,
                                            longitudinalMeters: 5000)
            mapView.setRegion(region, animated: true)
            isFirstLocationUpdate = false
        }
        
        mapView.showsUserLocation = true
    }
}

