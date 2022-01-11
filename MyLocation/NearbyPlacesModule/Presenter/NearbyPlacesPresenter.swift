//
//  NearbyPlacesPresenter.swift
//  MyLocation
//
//  Created by Данил Фролов on 09.01.2022.
//

import Foundation
import UIKit
import CoreLocation

protocol NearbyPlacesViewProtocol: AnyObject {
    func setNearbyPlaces(_ places: [Place])
    func showErrorAlert(with message: String)
}

protocol NearbyPlacesViewPresenterProtocol: AnyObject {
    init(view: NearbyPlacesViewController, router: RouterProtocol, location: CLLocation?)
    func getNearbyPlaces()
}

class NearbyPlacesPresenter: NearbyPlacesViewPresenterProtocol {
    weak var view: NearbyPlacesViewController?
    var router: RouterProtocol
    var currentLocation: CLLocation?
    
    required init(view: NearbyPlacesViewController, router: RouterProtocol, location: CLLocation?) {
        self.view = view
        self.router = router
        self.currentLocation = location
    }
    
    func getNearbyPlaces() {
        PlacesManager.shared.getPlaces(for: currentLocation) { [weak self] result in
            guard let strongSelf = self else {return}
            
            switch result {
            case .failure(let error):
                let message = "Failed to get places: \(error)"
                strongSelf.view?.showErrorAlert(with: message)
            case .success(let placesArray):
                strongSelf.view?.setNearbyPlaces(placesArray)
            }
        }
    }
}
