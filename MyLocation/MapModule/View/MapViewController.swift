//
//  MapViewController.swift
//  MyLocation
//
//  Created by Данил Фролов on 20.12.2021.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    //MARK: - UI Elements -
    private lazy var nearbyPlacesButton: UIButton  = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let icon = UIImage(systemName: "doc.plaintext.fill")
        button.backgroundColor = .white
        button.layer.cornerRadius = button.frame.width/2
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self,
                         action: #selector(nearbyPlacesButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: - Variables -
    var presenter: MapViewPresenterProtocol!
    private var mapView = GMSMapView()
    
    private var currentLocation: CLLocation? {
        didSet {
            if let location = currentLocation,
               oldValue == nil {
                setupCurrentLocation(location)
                mapView.isHidden = false
            }
        }
    }
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        createMapWithDefaultLocation()
        configureMapView()
        addSubViews()
        setupLocationManager()
        setupNearbyPlacesButtonConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupNavigationBar(isHidden: false)
    }
    
    //MARK: - Private -
    private func setupNavigationBar(isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }
    
    private func createMapWithDefaultLocation() {
        let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 15)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
    }
    
    private func configureMapView() {
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        mapView.isHidden = true
    }
    
    private func addSubViews() {
        view.addSubview(mapView)
        view.addSubview(nearbyPlacesButton)
    }
    
    private func setupNearbyPlacesButtonConstraints() {
        nearbyPlacesButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-10)
            make.height.width.equalTo(50)
        }
    }
    
    private func setupLocationManager() {
        CustomLocationManager.shared.delegate = self
        CustomLocationManager.shared.startTracking()
    }
    
    private func setupCurrentLocation(_ location: CLLocation) {
        let coordinate = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                              longitude: coordinate.longitude,
                                              zoom: 15)
        mapView.animate(to: camera)
    }
    
    @objc private func nearbyPlacesButtonTapped() {
        let viewController = NearbyPlacesViewController()
        if let latitude = currentLocation?.coordinate.latitude,
           let longitude = currentLocation?.coordinate.longitude {
            let coordinateString = "\(latitude.debugDescription),\(longitude.debugDescription)"
            viewController.currentLocation = coordinateString
        }
        navigationController?.pushViewController(viewController, animated: false)
    }
}

//MARK: - Extension -
extension MapViewController: CustomLocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        currentLocation = location
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        let decoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        mapView.clear()
        
        decoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.createTitle(on: marker, with: placemarks)
        }
    }
    
    func createTitle(on marker: GMSMarker, with placemarks: [CLPlacemark]?) {
        guard let placeMark = placemarks?.first else {
            return
        }
        
        guard let placeName = placeMark.name ??
                placeMark.subThoroughfare ??
                placeMark.thoroughfare else {
                    return
                }
        
        var address = ""
        if let subLocality = placeMark.subLocality ?? placeMark.name {
            address.append(subLocality)
        }
        if let city = placeMark.locality ?? placeMark.subAdministrativeArea {
            address.addingDevidingPrefixIfNeeded()
            address.append(city)
        }
        if let state = placeMark.administrativeArea {
            address.addingDevidingPrefixIfNeeded()
            address.append(state)
        }
        if let country = placeMark.country {
            address.addingDevidingPrefixIfNeeded()
            address.append(country)
        }
        
        marker.title = placeName
        marker.snippet = address
        marker.appearAnimation = .pop
        marker.map = mapView
    }
}

extension MapViewController: MapViewProtocol {
    
}