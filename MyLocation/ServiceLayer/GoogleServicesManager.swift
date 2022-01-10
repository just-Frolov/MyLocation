//
//  MapViewManager.swift
//  MyLocation
//
//  Created by Данил Фролов on 30.12.2021.
//

import GoogleMaps
import GooglePlaces

class GoogleServicesManager {
    private let apiKey = "AIzaSyDCA2pdlOV7pMWTVRGsKLaYYKPJxl1XC5g"
    
    func startService() {
        GMSServices.provideAPIKey(apiKey)
        GMSPlacesClient.provideAPIKey(apiKey)
    }
}
