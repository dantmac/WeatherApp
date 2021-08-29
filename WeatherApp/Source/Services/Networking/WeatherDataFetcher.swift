//
//  WeatherDataFetcher.swift
//  WeatherApp
//
//  Created by admin on 21.07.2021.
//

import Foundation
import UIKit

protocol WeatherDataFetcherProtocol {
    func fetchWeather(lon: String, lat: String, completion: @escaping RequestResult<WeatherResponse>)
}

struct WeatherDataFetcher: WeatherDataFetcherProtocol {
    
    // MARK: - Keys
    
    private enum Keys {
        static let lon = "lon"
        static let lat = "lat"
    }
    
    // MARK: - Properties
    
    let networkService: NetworkServiceProtocol
    
    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Weather Data Fetching
    
    func fetchWeather(lon: String, lat: String, completion: @escaping RequestResult<WeatherResponse>) {
        let params = [Keys.lat: lat, Keys.lon: lon]
        
        networkService.sendRequest(params: params) { result in
            switch result {
            case .success(let data):
                guard let decoded = self.decodeJSON(type: WeatherResponse.self, from: data) else { return }
                
                completion(.success(decoded))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = data, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
