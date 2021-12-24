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
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
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
    var currentLocation: CLLocation? {
        didSet {
            if oldValue == nil && currentLocation != nil {
                let region = MKCoordinateRegion(center: currentLocation!.coordinate, //???
                                                latitudinalMeters: 5000,
                                                longitudinalMeters: 5000)
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomLocationManager.shared.startTracking()
        CustomLocationManager.shared.delegate = self
        addSubviews()
        setMapViewLocation()
        setLocationButtonConstraints()
        addPinGestureRecognizer()
    }
    
    //MARK: - Private -
    private func addSubviews() {
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
    
    private func addPinGestureRecognizer() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(addPin(press:)))
        longPressRecognizer.minimumPressDuration = 1.0
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
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                print("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            var annotationTitle = String()
            var annotationSubTitle = String()
            let places = placemarks ?? []
            
            if !places.isEmpty {
                guard let placeMark = places.first else { return }
                if let street = placeMark.thoroughfare {
                    annotationTitle += street
                }
                if let house = placeMark.subThoroughfare {
                    annotationTitle += house
                }
                if let country = placeMark.country {
                    annotationSubTitle += country
                }
                if let city = placeMark.subLocality {
                    annotationSubTitle += city
                }
 
                annotation.title = annotationTitle.isEmpty ? self.defaultAnnotationTitle(for: location) : annotationTitle
                annotation.subtitle = annotationSubTitle

                self.mapView.addAnnotation(annotation)
            } else {
                annotation.title = self.defaultAnnotationTitle(for: location)
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func defaultAnnotationTitle(for location: CLLocation) -> String {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        return "\(latitude) + \(longitude)"
    }
}

//MARK: - CLLocation Manager Delegate -
extension ViewController: CustomLocationManagerDelegate {
    func customLocationManager(didUpdate locations: [CLLocation]) {
        setCurrentRegion(locations)
        mapView.showsUserLocation = true
    }
    
    func setCurrentRegion(_ locations: [CLLocation]) {
        currentLocation = locations.last
    }
}

