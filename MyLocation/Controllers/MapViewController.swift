//
//  MapViewController.swift
//  MyLocation
//
//  Created by Данил Фролов on 20.12.2021.
//
import GoogleMaps
import GooglePlaces
import UIKit

class MapViewController: UIViewController {
    
    //MARK: - UI Elements -
    lazy var nearbyPlacesButton: UIButton  = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let icon = UIImage(systemName: "doc.plaintext.fill")
        button.backgroundColor = .white
        button.layer.cornerRadius = button.frame.width/2
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self,
                         action: #selector(wasPressedNearbyPlacesButton),
                         for: .touchUpInside)
        return button
    }()
    
    private let searchRadius: Double = 1000

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
        setupSubView()
        setNearbyPlacesButtonConstraints()
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
    
    private func setupSubView() {
        view.addSubview(mapView)
        view.addSubview(nearbyPlacesButton)
        mapView.isHidden = true
    }
    
    private func setNearbyPlacesButtonConstraints() {
        let sizeNearbyPlacesButton: CGFloat = 50
        let spaceAtTopForNearbyPlacesButton: CGFloat = 30
        let spaceAtRightForNearbyPlacesButton: CGFloat = -10
        
        nearbyPlacesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nearbyPlacesButton.widthAnchor.constraint(equalToConstant: sizeNearbyPlacesButton),
            nearbyPlacesButton.heightAnchor.constraint(equalToConstant: sizeNearbyPlacesButton),
            nearbyPlacesButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spaceAtTopForNearbyPlacesButton),
            nearbyPlacesButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: spaceAtRightForNearbyPlacesButton)
        ])
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
    
    @objc func wasPressedNearbyPlacesButton() {
        let vc = NearbyPlacesViewController()
        vc.title = "Nearby Places"
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
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
