//
//  NetworkService.swift
//  WeatherApp
//
//  Created by admin on 20.07.2021.
//

import Foundation

protocol NetworkServiceProtocol {
    func sendRequest(params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    func sendRequest(params: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        
        var allParams = params
        allParams["appid"] = OpenWeatherAPI.key
        let url = self.url(params: allParams)
        let request = URLRequest(url: url)
        
        createDataTask(from: request, completion: completion).resume()
    
        print(url)
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void)  -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.weatherData
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url!
    }
}
