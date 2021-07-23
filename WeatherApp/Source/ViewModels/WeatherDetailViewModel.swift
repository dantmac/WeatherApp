//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by admin on 21.07.2021.
//

import Foundation

class WeatherDetailViewModel {
    
    private var fetcher: DataFetcher = WeatherDataFetcher(networkService: NetworkService())
    
    func getWeather() {
        fetcher.getWeather { response in
            guard let response = response else { return }
            print(response.timezone)
        }
    }

}
