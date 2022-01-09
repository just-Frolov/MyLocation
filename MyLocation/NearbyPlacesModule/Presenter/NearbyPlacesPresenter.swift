//
//  NearbyPlacesPresenter.swift
//  MyLocation
//
//  Created by Данил Фролов on 09.01.2022.
//

import Foundation
import UIKit

protocol NearbyPlacesViewProtocol: AnyObject {
    func success()
    func failure(with error: Error)
}

protocol NearbyPlacesViewPresenterProtocol: AnyObject {
    init(view: NearbyPlacesViewController, networkService: PlacesManager, router: RouterProtocol)
    func getNearbyPlaces(for location: String)
}

class NearbyPlacesPresenter: NearbyPlacesViewPresenterProtocol {
    weak var view: NearbyPlacesViewController?
    let networkService: PlacesManager
    var router: RouterProtocol
    
    required init(view: NearbyPlacesViewController, networkService: PlacesManager, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    func getNearbyPlaces(for location: String) {
        PlacesManager.shared.getPlaces(for: location) { [weak self] result in
            guard let strongSelf = self else {return}
            //strongSelf.spinner.dismiss(animated: true)
            
            switch result {
            case .failure(let error):
                strongSelf.view?.failure(with: error)
            case .success(let placesArray):
                strongSelf.view?.success()
            }
        }
    }
}
