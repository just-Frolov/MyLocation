//
//  AsselderModuleBuilder.swift
//  MyLocation
//
//  Created by Данил Фролов on 09.01.2022.
//

import UIKit
import CoreLocation

protocol AssemblerBuilderProtocol {
    func createMapModule(router: RouterProtocol) -> UIViewController
    func createNearbyPlacesModule(with location: CLLocation?, router: RouterProtocol) -> UIViewController
}

class AssemblerModuleBuilder: AssemblerBuilderProtocol {
    func createMapModule(router: RouterProtocol) -> UIViewController {
        let view = MapViewController()
        let presenter = MapPresenter(view: view,
                                      router: router)
        view.presenter = presenter
        return view
    }
    
    func createNearbyPlacesModule(with location: CLLocation?, router: RouterProtocol) -> UIViewController {
        let view = NearbyPlacesViewController()
        let presenter = NearbyPlacesPresenter(view: view,
                                              networkService: PlacesManager.shared,
                                              router: router,
                                              location: location)
        view.presenter = presenter 
        return view
    }
}
