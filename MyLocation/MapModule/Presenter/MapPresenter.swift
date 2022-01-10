//
//  MapPresenter.swift
//  MyLocation
//
//  Created by Данил Фролов on 09.01.2022.
//

import Foundation
import GoogleMaps

protocol MapViewProtocol: AnyObject {
    var mapView: GMSMapView {get set}
    func showCurrentLocation(_ location: CLLocation)
    func setupMapView()
    func showMapView()
    func createMarkerWithTitle(placeName: String, address: String, at coordinate: CLLocationCoordinate2D)
}

protocol MapViewPresenterProtocol: AnyObject {
    var currentLocation: CLLocation? { get set }
    init(view: MapViewProtocol, router: RouterProtocol)
    func setupLocationManager()
    func configureMapView()
    func createPlaceInfo(for coordinate: CLLocationCoordinate2D)
    func nearbyPlacesButtonTapped()
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
        self.view = view
        self.router = router
    }
    
    func setupLocationManager() {
        CustomLocationManager.shared.delegate = self
        CustomLocationManager.shared.startTracking()
    }
    
    func configureMapView() {
        view?.setupMapView()
        view?.mapView.delegate = self
    }
    
    func nearbyPlacesButtonTapped() {
        if let latitude = currentLocation?.coordinate.latitude,
           let longitude = currentLocation?.coordinate.longitude {
            let coordinateString = "\(latitude.debugDescription),\(longitude.debugDescription)"
            router?.showNearbyPlaces(in: coordinateString)
        }
    }
}

//MARK: - CustomLocationManagerDelegate -
extension MapPresenter: CustomLocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        currentLocation = location
    }
}

//MARK: - GMSMapViewDelegate -
extension MapPresenter: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        createPlaceInfo(for: coordinate)
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
}
