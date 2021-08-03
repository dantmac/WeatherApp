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
    func countHourlyCells() -> Int
    func countDailyCells() -> Int
    func presentCityListVC()
}

final class DetailWeatherViewViewModel: DetailWeatherPresentationLogic {
    
    // TODO: consider refactoring Table&Collection's datareload
    
    weak var viewController: DetailViewDisplayLogic?
    var coordinator: DetailWeatherCoordinator?
    private var fetcher: DataFetcher = WeatherDataFetcher(networkService: NetworkService())
    
    private var hourlyCellViewModel = HourlyCellViewModel(cells: [])
    private var dailyCellViewModel = DailyCellViewModel(cells: [])
    
    func presentWeather() {
        displayWeather()
    }
    
    func presentCityListVC() {
        coordinator?.startCityListVC()
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
            let preparedHourlyCells = self.configurateHourlyView(hourlyCellViewModel: hourlyCells,
                                                                 response: responseDetail)
            let fixedHourlyCells = Array(preparedHourlyCells.prefix(26))
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
    
    func countHourlyCells() -> Int {
        return hourlyCellViewModel.cells.count
    }
    
    func countDailyCells() -> Int {
        return dailyCellViewModel.cells.count
    }
    
    private func configurateHourlyView(hourlyCellViewModel: [HourlyCellViewModelProtocol], response: WeatherResponse) -> [HourlyCellViewModelProtocol] {
        
        let sunrise = Int(response.current.sunriseDate.formateToHours())
        let sunset = Int(response.current.sunsetDate.formateToHours())
        
        var preparedModel = [HourlyCellViewModelProtocol]()
        var cell = HourlyCellViewModel.HourlyCell(dtHourly: "", temp: "", weatherIcon: "")
        
        for (i, j) in hourlyCellViewModel.enumerated() {
            if i == 0 {
                cell.dtHourly = "Now"
                cell.temp = j.temp
                cell.weatherIcon = j.weatherIcon
                preparedModel.insert(cell, at: 0)
            } else {
                cell.dtHourly = j.dtHourly
                cell.temp = j.temp
                cell.weatherIcon = j.weatherIcon
                preparedModel.append(cell)
            }
        }
        
        for (i, j) in preparedModel.enumerated() {
            let time = Int(j.dtHourly)
            
            if (sunrise ?? 0) >= ((time ?? 0) - 1) && (sunrise ?? 0) < (time ?? 0) {
                cell.dtHourly = response.current.sunriseDate.formateToTime(timezoneOffset: response.timezoneOffset)
                cell.weatherIcon = "sunrise"
                cell.temp = "Sunrise"
                preparedModel.insert(cell, at: i)
            }
        }
        
        for (i, j) in preparedModel.enumerated() {
            let time = Int(j.dtHourly)
            
            if (sunset ?? 0) >= ((time ?? 0) - 1) && (sunset ?? 0) < (time ?? 0) {
                cell.dtHourly = response.current.sunsetDate.formateToTime(timezoneOffset: response.timezoneOffset)
                cell.weatherIcon = "sunset"
                cell.temp = "Sunset"
                preparedModel.insert(cell, at: i)
            }
        }
        
        return preparedModel
    }
}
