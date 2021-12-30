//
//  PlacesManager.swift
//  MyLocation
//
//  Created by Данил Фролов on 30.12.2021.
//

import Foundation
import Alamofire

struct PlacesManager {
    //MARK: - Static Constants -
    static let shared = PlacesManager()
    
    //MARK: - Private Constants -
    private let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    private let typeString = "?type=restaurant"
    private let radiusString = "&radius=1500"
    
    //MARK: - Public -
    public func getPlaces(for location: String, completion: @escaping (Result<[Places], Error>) -> Void) {
        let urlString = baseURL + typeString + radiusString + location
        
        AF.request(urlString).responseJSON { responce in
            guard responce.error == nil else {
                completion(.failure(RequestError.failedResponseJSON))
                return
            }
            if let safeData = responce.data {
                if let places = parseJson(safeData) {
                    completion(.success(places))
                } else {
                    completion(.failure(RequestError.failedParseJson))
                }
            } else {
                completion(.failure(RequestError.failedResponseJSON))
            }
        }
    }
    
    //MARK: - Private -
    private func parseJson(_ data: Data) -> [Places]? {
        let decoder = JSONDecoder()
        do {
            let decodateData = try decoder.decode(PlacesData.self, from: data)
            return decodateData.results
        } catch {
            return nil
        }
    }
    
    private enum RequestError: Error {
        case failedResponseJSON
        case failedParseJson
    }
}
