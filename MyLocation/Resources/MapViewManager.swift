//
//  MapViewManager.swift
//  MyLocation
//
//  Created by Данил Фролов on 30.12.2021.
//

import GoogleMaps
import GooglePlaces

class MapViewManager {
    private let apiKey = "AIzaSyDCA2pdlOV7pMWTVRGsKLaYYKPJxl1XC5g"
    
    private func setApiKey() {
        GMSServices.provideAPIKey(apiKey)
        GMSPlacesClient.provideAPIKey(apiKey)
    }
}
