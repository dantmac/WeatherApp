//
//  NetworkDataFetcher.swift
//  WeatherApp
//
//  Created by admin on 21.07.2021.
//

import Foundation

protocol DataFetcher {
    func getWeather(response: @escaping (WeatherResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func getWeather(response: @escaping (WeatherResponse?) -> Void) {
        
        let params = ["lat": "33.44", "lon": "-94.04"]
        networking.request(params: params) { data, error in
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
