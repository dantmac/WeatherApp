//
//  DailyCellViewViewModel.swift
//  WeatherApp
//
//  Created by admin on 26.07.2021.
//

import Foundation

class DailyCellViewViewModel {
    
    private var fetcher: DataFetcher = WeatherDataFetcher(networkService: NetworkService())
    
    func setWeather(completion: @escaping (DailyCellViewModel) -> Void) {
        fetcher.getWeather { [unowned self] response in
            guard let response = response else { return }
            let dailyRespone = response.daily
            let cells = dailyRespone.map { weatherDaily in
                self.setDailyCell(from: weatherDaily)
            }
                
            let dailyCellViewModel = DailyCellViewModel(cells: cells)
            completion(dailyCellViewModel)
        }
    }
    
    private func setDailyCell(from response: WeatherDaily) -> DailyCellViewModel.DailyCell {
        let weather = response.weather
        let icon = weather.map { weather in weather.icon }
        return DailyCellViewModel.DailyCell(dtDaily: response.dtDate.formateToDays(),
                                            weatherIcon: icon[0],
                                            tempMax: response.temp.maxCelsiusString,
                                            tempMin: response.temp.minCelsiusString)
        }
}
