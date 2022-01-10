//
//  Router.swift
//  MyLocation
//
//  Created by Данил Фролов on 09.01.2022.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblerBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showNearbyPlaces(in location: String)
    func popToRoot()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblerBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblerBuilderProtocol) {
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
        guard let detailViewController = assemblyBuilder?.createNearbyPlacesModule(with: location, router: self) else { return }
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func popToRoot() {
            navigationController?.popToRootViewController(animated: true)
    }
}
