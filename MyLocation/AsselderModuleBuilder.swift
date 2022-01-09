//
//  AsselderModuleBuilder.swift
//  MyLocation
//
//  Created by Данил Фролов on 09.01.2022.
//

import UIKit

protocol AsselderBuilderProtocol {
    func createMapModule(view: MapViewController, router: RouterProtocol) -> UIViewController
    func createNearbyPlacesModule(view: NearbyPlacesViewController, coordinate: String?, router: RouterProtocol) -> UIViewController
}

class AsselderModuleBuilder: AsselderBuilderProtocol {
    func createMapModule(view: MapViewController, router: RouterProtocol) -> UIViewController {
        let presenter = MapPresenter(view: view,
                                      router: router)
        view.presenter = presenter
        return view
    }
    
    func createNearbyPlacesModule(view: NearbyPlacesViewController, coordinate: String?, router: RouterProtocol) -> UIViewController {
        let networkService = PlacesManager()
        let presenter = NearbyPlacesPresenter(view: view,
                                              networkService: networkService,
                                              router: router)
        view.presenter = presenter 
        return view
    }
}
