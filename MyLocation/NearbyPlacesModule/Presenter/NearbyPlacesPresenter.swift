//
//  NearbyPlacesPresenter.swift
//  MyLocation
//
//  Created by Данил Фролов on 09.01.2022.
//

import Foundation
import UIKit

protocol NearbyPlacesViewProtocol: AnyObject {
    func success(with places: [Place])
    func failure(with error: Error)
}

protocol NearbyPlacesViewPresenterProtocol: AnyObject {
    init(view: NearbyPlacesViewController, networkService: PlacesManager, router: RouterProtocol, location: String)
    func getNearbyPlaces()
}

class NearbyPlacesPresenter: NearbyPlacesViewPresenterProtocol {
    weak var view: NearbyPlacesViewController?
    let networkService: PlacesManager
    var router: RouterProtocol
    var currentLocation: String
    
    required init(view: NearbyPlacesViewController, networkService: PlacesManager, router: RouterProtocol, location: String) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.currentLocation = location
    }
    
    func getNearbyPlaces() {
        let locationString = "&location=\(currentLocation)"
        PlacesManager.shared.getPlaces(for: locationString) { [weak self] result in
            guard let strongSelf = self else {return}
            
            switch result {
            case .failure(let error):
                strongSelf.view?.failure(with: error)
            case .success(let placesArray):
                strongSelf.view?.success(with: placesArray)
            }
        }
    }
}
