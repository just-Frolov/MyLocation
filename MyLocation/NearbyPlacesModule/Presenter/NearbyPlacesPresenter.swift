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
    func gotNearbyPlaces(_ places: [Place])
    func gotError(with message: Error)
}

protocol NearbyPlacesViewPresenterProtocol: AnyObject {
    init(view: NearbyPlacesViewController, networkService: PlacesManager, router: RouterProtocol, location: CLLocation?)
    func getNearbyPlaces()
}

class NearbyPlacesPresenter: NearbyPlacesViewPresenterProtocol {
    weak var view: NearbyPlacesViewController?
    let networkService: PlacesManager
    var router: RouterProtocol
    var currentLocation: CLLocation?
    
    required init(view: NearbyPlacesViewController, networkService: PlacesManager, router: RouterProtocol, location: CLLocation?) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.currentLocation = location
    }
    
    func getNearbyPlaces() {
        networkService.getPlaces(for: currentLocation) { [weak self] result in
            guard let strongSelf = self else {return}
            
            switch result {
            case .failure(let error):
                strongSelf.view?.gotError(with: error)
            case .success(let placesArray):
                strongSelf.view?.gotNearbyPlaces(placesArray)
            }
        }
    }
}
