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
    var mapView = GMSMapView()
    var presenter: MapViewPresenterProtocol!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        createMapWithDefaultLocation()
        presenter.configureMapView()
        addSubViews()
        presenter.setupLocationManager()
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
    
    @objc private func nearbyPlacesButtonTapped() {
        presenter.nearbyPlacesButtonTapped()
    }
}

//MARK: - Extension -
//MARK: - MapViewProtocol -
extension MapViewController: MapViewProtocol {
    func setupMapView() {
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.isHidden = true
    }
    
    func showCurrentLocation(_ location: CLLocation) {
        let coordinate = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                              longitude: coordinate.longitude,
                                              zoom: 15)
        mapView.animate(to: camera)
    }
    
    func showMapView() {
        mapView.isHidden = false
    }
    
    func createMarkerWithTitle(placeName: String, address: String, at coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        mapView.clear()
        marker.title = placeName
        marker.snippet = address
        marker.appearAnimation = .pop
        marker.map = mapView
    }
}
