//
//  MapPresenter.swift
//  MyLocation
//
//  Created by Данил Фролов on 09.01.2022.
//

import Foundation
import GoogleMaps

protocol MapViewProtocol: AnyObject {
    func showCurrentLocation(_ location: CLLocation)
    func showMapView()
    func createMarkerWithTitle(placeName: String, address: String, at coordinate: CLLocationCoordinate2D)
}

protocol MapViewPresenterProtocol: AnyObject {
    var currentLocation: CLLocation? { get set }
    init(view: MapViewProtocol, router: RouterProtocol)
    func createPlaceInfo(for coordinate: CLLocationCoordinate2D)
    func nearbyPlacesButtonTapped()
    func viewDidLoad()
}

class MapPresenter: NSObject, MapViewPresenterProtocol {
    weak var view: MapViewProtocol?
    var router: RouterProtocol?
    var currentLocation: CLLocation? {
        didSet {
            if let location = currentLocation,
               oldValue == nil {
                view?.showCurrentLocation(location)
                view?.showMapView()
            }
        }
    }
    
    required init(view: MapViewProtocol, router: RouterProtocol) {
        super.init()
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        self.setupLocationManager()
    }
    
    //MARK: - Private -
    func nearbyPlacesButtonTapped() {
        router?.showNearbyPlaces(in: currentLocation)
    }
    
    func createPlaceInfo(for coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let decoder = CLGeocoder()
        
        decoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
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
            self?.view?.createMarkerWithTitle(placeName: placeName, address: address, at: coordinate)
        }
    }
    
    //MARK: - Private -
    private func setupLocationManager() {
        CustomLocationManager.shared.delegate = self
        CustomLocationManager.shared.startTracking()
    }
}

//MARK: - CustomLocationManagerDelegate -
extension MapPresenter: CustomLocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        currentLocation = location
    }
}


    
    

