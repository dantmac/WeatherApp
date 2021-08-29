//
//  NetworkService.swift
//  WeatherApp
//
//  Created by admin on 20.07.2021.
//

import Foundation

typealias RequestParams = [String: String]

protocol NetworkServiceProtocol {
    func sendRequest(params: RequestParams, completion: @escaping RequestResult<Data>)
}

struct NetworkService: NetworkServiceProtocol {

    func sendRequest(params: RequestParams, completion: @escaping RequestResult<Data>) {
        
        var allParams = params
        allParams[OpenWeatherAPI.appID] = OpenWeatherAPI.key
        let url = self.url(params: allParams)
        let request = URLRequest(url: url)
        
        createDataTask(from: request, completion: completion).resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping RequestResult<Data>) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(error ?? AppError.error as! Error))
                    return
                }
                
                completion(.success(data))
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
