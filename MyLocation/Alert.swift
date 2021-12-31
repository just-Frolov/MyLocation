//
//  Alert.swift
//  MyLocation
//
//  Created by Данил Фролов on 20.12.2021.
//

import UIKit

extension MapViewController {
    typealias EmptyBlock = () -> Void
    
    func alertAddAdress(completionHanler: EmptyBlock) {
        let alertController = UIAlertController(title: "Add Adress", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { tf in
            tf.placeholder = "adress"
        }
        
        let alertActionOK = UIAlertAction(title: "OK", style: .default) { action in
            _ = alertController.textFields?.first
            
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default) { _ in
            
        }
        
        alertController.addAction(alertActionOK)
        alertController.addAction(alertActionCancel)
        
        alertController.present(alertController, animated: true, completion: nil )
    }
}
