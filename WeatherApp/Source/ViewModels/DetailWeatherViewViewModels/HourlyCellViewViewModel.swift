//
//  HourlyCellViewViewModel.swift
//  WeatherApp
//
//  Created by admin on 25.07.2021.
//

import Foundation

class HourlyCellViewViewModel {
    
    private var fetcher: DataFetcher = WeatherDataFetcher(networkService: NetworkService())
    
    func setWeather(completion: @escaping (HourlyCellViewModel) -> Void) {
        fetcher.getWeather { [unowned self] response in
            guard let response = response else { return }
            let hourlyRespone = response.hourly
            let cells = Array(hourlyRespone.map { weatherHourly in
                self.setHourlyCell(from: weatherHourly)
            }.prefix(25))
                
            let hourlyCellViewModel = HourlyCellViewModel(cells: cells)
            completion(hourlyCellViewModel)
        }
    }
    
    private func setHourlyCell(from response: WeatherHourly) -> HourlyCellViewModel.HourlyCell {
        let weather = response.weather
        let icon = weather.map { weather in weather.icon }
        return HourlyCellViewModel.HourlyCell(dtHourly: response.dtDate.formateToHours(),
                                              temp: response.tempCelsiusString,
                                              weatherIcon: icon[0])
        }
}
