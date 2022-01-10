//
//  ErrorAlert.swift
//  MyLocation
//
//  Created by Данил Фролов on 10.01.2022.
//

import UIKit

extension NearbyPlacesViewController {
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
