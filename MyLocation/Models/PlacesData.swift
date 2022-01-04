//
//  PlacesData.swift
//  MyLocation
//
//  Created by Данил Фролов on 30.12.2021.
//

import Foundation

struct PlacesData: Decodable {
    let results: [Places]
}

struct Places: Decodable {
    var name: String
    var icon: String
    var vicinity: String
    var opening_hours: IsOpen?
    var rating: Double?
}

struct IsOpen: Decodable {
    var open_now: Bool
}
