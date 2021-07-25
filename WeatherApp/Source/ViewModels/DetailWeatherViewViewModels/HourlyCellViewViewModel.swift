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
            let cells = hourlyRespone.map { weatherHourly in
                self.getHourlyCell(from: weatherHourly)
            }
                
            let hourlyCellViewModel = HourlyCellViewModel(cells: cells)
            completion(hourlyCellViewModel)
        }
    }
    
    private func getHourlyCell(from response: WeatherHourly) -> HourlyCellViewModel.HourlyCell {
        let weather = response.weather
        let icon = weather.map { weather in weather.icon }
        return HourlyCellViewModel.HourlyCell(dtHourly: response.dtDate.formateToHours(),
                                              temp: response.tempCelsiusString,
                                              weatherIcon: icon[0])
        }
    
//    private func getHourlyCell(from response: WeatherResponse) -> HourlyCellViewModelProtocol {
//        let timezoneOffset = response.timezoneOffset
//        var icon = ""
//        var temp = ""
//        var date = Date(timeIntervalSince1970: 0)
//        response.hourly.map { hourlyItem in
//            let weatherIcon = hourlyItem.weather.map { weather in weather.icon }
//            icon = weatherIcon[0]
//            temp = hourlyItem.tempCelsiusString
//            date = hourlyItem.dtDate
//        }
//
//        let hourlyCellViewModel = setHourlyCell(date: date,
//                                                temp: temp,
//                                                icon: icon,
//                                                timezoneOffset: timezoneOffset)
//        return hourlyCellViewModel
//    }
//
//    private func setHourlyCell(date: Date, temp: String, icon: String, timezoneOffset: Int) -> HourlyCellViewModel.HourlyCell {
//        return HourlyCellViewModel.HourlyCell(dtHourly: date.formateToHours(timezoneOffset: timezoneOffset),
//                                              temp: temp,
//                                              weatherIcon: icon)
//    }
}
