//
//  MapPresenter.swift
//  MyLocation
//
//  Created by Данил Фролов on 09.01.2022.
//

import Foundation

protocol MapViewProtocol: AnyObject {
    
}

protocol MapViewPresenterProtocol: AnyObject {
    init(view: MapViewProtocol, router: RouterProtocol)
    func nearbyPlacesButtonTaped(location: String)
}

class MapPresenter: MapViewPresenterProtocol {
    weak var view: MapViewProtocol?
    var router: RouterProtocol?
    
    required init(view: MapViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    public func nearbyPlacesButtonTaped(location: String) {
        router?.showNearbyPlaces(in: location)
    }
}
