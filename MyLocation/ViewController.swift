//
//  ViewController.swift
//  MyLocation
//
//  Created by Данил Фролов on 20.12.2021.
//
import GoogleMaps
import GooglePlaces
import UIKit

class ViewController: UIViewController {
    //MARK: - Variables -
    private var mapView = GMSMapView()
    private var placesClient: GMSPlacesClient!
    
    private var currentLocation: CLLocation? {
        didSet {
            if let location = currentLocation,
               oldValue == nil {
                setCurrentLocation(location)
                mapView.isHidden = false
            }
        }
    }
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        createMapWithDefaultLocation()
        setMapView()
        addMapView()
        setLocationManager()
        setPlacesClient()
    }
    
    //MARK: - Private -
    private func createMapWithDefaultLocation() {
        let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 15)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
    }
    
    private func setMapView() {
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    private func addMapView() {
        view.addSubview(mapView)
        mapView.isHidden = true
    }
    
    private func setLocationManager() {
        CustomLocationManager.shared.delegate = self
        CustomLocationManager.shared.startTracking()
    }
    
    private func setPlacesClient() {
        placesClient = GMSPlacesClient.shared()
    }
    
    private func setCurrentLocation(_ location: CLLocation) {
        let coordinate = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                              longitude: coordinate.longitude,
                                              zoom: 15)
        mapView.animate(to: camera)
    }
}

//MARK: - Extension -
extension ViewController: CustomLocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        currentLocation = location
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let marker = GMSMarker(position: position)
        setTitle(to: marker)
        marker.map = mapView
    }
    
    func setTitle(to marker: GMSMarker) {
        let placeFields: GMSPlaceField = [.name, .formattedAddress]
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { (placeLikelihoods, error) in
            guard error == nil else {
                print("Current place error: \(error?.localizedDescription ?? "")")
                return
            }
            
            guard let place = placeLikelihoods?.first?.place else {
                marker.title = "No current place"
                marker.snippet = ""
                return
            }
            
            marker.title = place.name
            marker.snippet = place.formattedAddress
        }
    }
}
