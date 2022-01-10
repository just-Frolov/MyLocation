//
//  PlacesData.swift
//  MyLocation
//
//  Created by Данил Фролов on 30.12.2021.
//

import Foundation

struct PlacesData: Codable {
    let results: [Place]
}

struct Place: Codable {
    let icon: String
    let name: String
    let openingHours: OpeningHours?
    let rating: Double?
    let vicinity: String

    enum CodingKeys: String, CodingKey {
        case icon, name
        case openingHours = "opening_hours"
        case rating, vicinity
    }
}

struct OpeningHours: Codable {
    let openNow: Bool

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}
