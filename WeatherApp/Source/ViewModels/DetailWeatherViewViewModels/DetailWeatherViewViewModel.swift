//
//  DetailWeatherViewViewModel.swift
//  WeatherApp
//
//  Created by admin on 21.07.2021.
//

import Foundation

protocol DetailWeatherPresentationLogic {
    
    func presentWeather()
    func setHourlyViewModel(for indexPath: IndexPath) -> HourlyCellViewModelProtocol
    func setDailyViewModel(for indexPath: IndexPath) -> DailyCellViewModelProtocol
    
    var hourlyCellViewModel: HourlyCellViewModel { get }
    var dailyCellViewModel: DailyCellViewModel { get }
}

class DetailWeatherViewViewModel: DetailWeatherPresentationLogic {
    
    // TODO: consider refactoring Table&Collection's datareload
    
    weak var viewController: DetailViewDisplayLogic?
    private var fetcher: DataFetcher = WeatherDataFetcher(networkService: NetworkService())
    
    var hourlyCellViewModel = HourlyCellViewModel(cells: [])
    var dailyCellViewModel = DailyCellViewModel(cells: [])
    
    func presentWeather() {
        displayWeather()
    }
    
    private func displayWeather() {
        presentWeather { [weak self] detailViewModel, hourlyCellViewModel, dailyCellViewModel in
            self?.hourlyCellViewModel = hourlyCellViewModel
            self?.dailyCellViewModel = dailyCellViewModel
            self?.viewController?.displayDetailWeather(detailViewModel: detailViewModel)
        }
    }
    
    private func presentWeather(completion: @escaping (DetailViewModelProtocol, HourlyCellViewModel, DailyCellViewModel) -> Void) {
        fetcher.getWeather { [weak self] response in
            guard let self = self,
                  let responseDetail = response else { return }
            
            let detailViewModel = self.setDetailViewModel(from: responseDetail)
            
            let responseHourly = responseDetail.hourly
            let hourlyCells = responseHourly.map { responseHourly in self.setHourlyViewModel(from: responseHourly) }
            let fixedHourlyCells = Array(hourlyCells.prefix(25))
            let hourlyCellViewModel = HourlyCellViewModel(cells: fixedHourlyCells)
            
            let responseDaily = responseDetail.daily
            let dailyCells = responseDaily.map { responseDaily in self.setDailyViewModel(from: responseDaily) }
            let dailyCellViewModel = DailyCellViewModel(cells: dailyCells)
            
            completion(detailViewModel, hourlyCellViewModel, dailyCellViewModel)
        }
    }
    
    private func setDetailViewModel(from response: WeatherResponse) -> DetailViewModelProtocol {
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
                               cloudiness: current.cloudsString,
                               windSpeed: current.windSpeedString,
                               windDeg: current.windDegString,
                               feelsLike: current.feelsLikeCelsiusString,
                               pressure: current.pressureString,
                               visibility: current.visibilityString,
                               uvi: current.uviString)
    }
    
    private func setHourlyViewModel(from response: WeatherHourly) -> HourlyCellViewModelProtocol {
        let weather = response.weather
        let icon = weather.map { weather in weather.icon }
        
        return HourlyCellViewModel.HourlyCell(dtHourly: response.dtDate.formateToHours(),
                                              temp: response.tempCelsiusString,
                                              weatherIcon: icon[0])
    }
    
    private func setDailyViewModel(from response: WeatherDaily) -> DailyCellViewModelProtocol {
        let weather = response.weather
        let icon = weather.map { weather in weather.icon }
        
        return DailyCellViewModel.DailyCell(dtDaily: response.dtDate.formateToDays(),
                                            weatherIcon: icon[0],
                                            tempMax: response.temp.maxCelsiusString,
                                            tempMin: response.temp.minCelsiusString)
    }
    
    func setHourlyViewModel(for indexPath: IndexPath) -> HourlyCellViewModelProtocol {
        let cellViewModel = hourlyCellViewModel.cells[indexPath.row]
        return cellViewModel
    }
    
    func setDailyViewModel(for indexPath: IndexPath) -> DailyCellViewModelProtocol {
        let cellViewModel = dailyCellViewModel.cells[indexPath.row]
        return cellViewModel
    }
}
