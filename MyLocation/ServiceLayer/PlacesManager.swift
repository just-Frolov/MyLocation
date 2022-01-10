//
//  PlacesManager.swift
//  MyLocation
//
//  Created by Данил Фролов on 30.12.2021.
//

import Alamofire

struct PlacesManager {
    //MARK: - Static Constants -
    static let shared = PlacesManager()
    
    //MARK: - Internal Constants -
    let radius = 5
    
    //MARK: - Private Constants -
    private let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    private let apiKeyString = "?key=AIzaSyDCA2pdlOV7pMWTVRGsKLaYYKPJxl1XC5g"
    private let typeString = "&type=restaurant"
    
    //MARK: - Internal -
    func getPlaces(for location: String, completion: @escaping (Result<[Place], Error>) -> Void) {
        let radiusInMeters = radius * 1000 //multiply by 1000, since the radius is set in meters
        let radiusString = "&radius=\(radiusInMeters)"
        let locationString = "&location=\(location)"
        let urlString = baseURL + apiKeyString + typeString + radiusString + locationString
        print(urlString)
        AF.request(urlString).responseJSON { response in
            guard response.error == nil else {
                completion(.failure(RequestError.failedResponseJSON))
                return
            }
            if let safeData = response.data {
                let places = parseJson(safeData) 
                completion(.success(places))
            } else {
                completion(.failure(RequestError.failedResponseJSON))
            }
        }
    }
    
    //MARK: - Private -
    private func parseJson(_ data: Data) -> [Place] {
        let decoder = JSONDecoder()
        do {
            let decodateData = try decoder.decode(PlacesData.self, from: data)
            return decodateData.results
        } catch {
            return []
        }
    }
    
    private enum RequestError: Error {
        case failedResponseJSON
        case failedParseJson
    }
    
    private enum GetImageError: Error {
        case failedCreateUrl
        case failedCreateData
        case failedCreateImage
    }
}
