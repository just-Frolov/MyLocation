//
//  Router.swift
//  MyLocation
//
//  Created by Данил Фролов on 09.01.2022.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AsselderBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showNearbyPlaces(in location: String)
    func popToRoot()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AsselderBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AsselderBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let viewController = assemblyBuilder?.createMapModule(router: self) else { return }
            navigationController.viewControllers = [viewController]
        }
    }
    
    func showNearbyPlaces(in location: String) {
        if let navigationController = navigationController {
            guard let detailViewController = assemblyBuilder?.createNearbyPlacesModule(with: location, router: self) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
