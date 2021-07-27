//
//  WeatherDataFetcher.swift
//  WeatherApp
//
//  Created by admin on 21.07.2021.
//

import Foundation

protocol DataFetcher {
    func getWeather(response: @escaping (WeatherResponse?) -> Void)
}

struct WeatherDataFetcher: DataFetcher {
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getWeather(response: @escaping (WeatherResponse?) -> Void) {
        print(#function)
        let params = ["lat": "52.01", "lon": "32.75"]
        networkService.sendRequest(params: params) { data, error in
            if let error = error {
                print("Error receiver requesting data: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: WeatherResponse.self, from: data)
            response(decoded)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
