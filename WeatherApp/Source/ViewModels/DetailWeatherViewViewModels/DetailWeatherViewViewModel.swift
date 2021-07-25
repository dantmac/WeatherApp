//
//  DetailWeatherViewViewModel.swift
//  WeatherApp
//
//  Created by admin on 21.07.2021.
//

import Foundation

class DetailWeatherViewViewModel {
    
    private var fetcher: DataFetcher = WeatherDataFetcher(networkService: NetworkService())
    
    func setWeather(completion: @escaping (DetailViewModelProtocol) -> Void) {
        fetcher.getWeather { [weak self] response in
            guard let response = response,
                  let detailViewModel = self?.setDetailView(from: response) else { return }
            completion(detailViewModel)
        }
    }
    
    private func setDetailView(from response: WeatherResponse) -> DetailViewModel {
        let current = response.current
        let daily = response.daily.first
       
        let descriptions = response.current.weather.map { weather in weather.descriptionStr }
        let description = descriptions[0]
        
        return DetailViewModel(location: response.location,
                               description: description,
                               temp: current.tempCelsiusString,
                               tempMax: "Max: " + (daily?.temp.maxCelsiusString ?? ""),
                               tempMin: "Min: " + (daily?.temp.minCelsiusString ?? ""),
                               sunrise: current.sunriseDate.formateToTime(timezoneOffset: response.timezoneOffset),
                               sunset: current.sunsetDate.formateToTime(timezoneOffset: response.timezoneOffset),
                               humidity: current.humidityString,
                               cloudness: current.cloudsString,
                               windSpeed: current.windSpeedString,
                               windDeg: current.windDegString,
                               feelsLike: current.feelsLikeCelsiusString,
                               pressure: current.pressureString,
                               visibility: current.visibilityString,
                               uvi: current.uviString)
    }
    
}
