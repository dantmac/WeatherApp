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
       
        let descriptions = response.current.weather.map { weather in weather.description }
        let description = descriptions[0]
        
        return DetailViewModel(location: response.timezone.deletingPrefix(),
                               description: description,
                               temp: current.tempCelsiusString,
                               tempMax: "Max: " + String(format: "%.f", (daily?.temp.max ?? 0) - 273) + "°",
                               tempMin: "Min: " + String(format: "%.f", (daily?.temp.min ?? 0) - 273) + "°",
                               sunrise: Date(timeIntervalSince1970: Double(current.sunrise)).formateToTime(),
                               sunset: Date(timeIntervalSince1970: Double(current.sunset)).formateToTime(),
                               humidity: String(current.humidity) + " %",
                               cloudness: String(current.clouds) + " %",
                               windSpeed: String(format: "%.1f", current.windSpeed) + " m/s",
                               windDeg: String(current.windDeg),
                               feelsLike: String(format: "%.f", current.feelsLike) + "°",
                               pressure: String(current.pressure),
                               visibility: String(current.visibility),
                               uvi: String(current.uvi))
        
    }
    
}
