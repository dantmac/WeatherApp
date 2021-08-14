//
//  DetailWeatherViewViewModel.swift
//  WeatherApp
//
//  Created by admin on 21.07.2021.
//

import UIKit
import Foundation

// TODO: - consider following Interface Segregation principle

protocol DetailWeatherPresentationLogic {
    func presentWeather()
    func setHourlyViewModel(for indexPath: IndexPath) -> HourlyCellViewModelProtocol
    func setDailyViewModel(for indexPath: IndexPath) -> DailyCellViewModelProtocol
    func countHourlyCells() -> Int
    func countDailyCells() -> Int
    
    func addCity()
    func popVC()
    func dismissVC(_ viewController: UIViewController)
}

final class DetailWeatherViewViewModel: DetailWeatherPresentationLogic {
    
    weak var viewController: DetailViewDisplayLogic?
    var coordinator: AppCoordinator?
    private var fetcher: DataFetcher = WeatherDataFetcher(networkService: NetworkService())
    private let coreDataManager = CoreDataManager()
    
    private var hourlyCellViewModel = HourlyCellViewModel(cells: [])
    private var dailyCellViewModel = DailyCellViewModel(cells: [])
    
    private var temp: String?
    private var description: String?
    private var timezoneOffset: Int?
    
    var cityName: String?
    var long: String?
    var lat: String?
    
   
    
    func presentWeather() {
        setWeather()
    }
    
    func popVC() {
        coordinator?.popDetailVC(self)
    }
    
    func dismissVC(_ viewController: UIViewController) {
        coordinator?.dismissDetailVC(viewController)
    }
    
    func addCity() {
        let date = NSDate() as Date
        let vc = viewController as! DetailWeatherViewController
        
        coreDataManager.saveCity(name: cityName ?? "",
                                 long: long ?? "00",
                                 lat: lat ?? "00",
                                 descript: description ?? "",
                                 temp: temp ?? "",
                                 dateAdded: date)
        
        coordinator?.appendVC(vc)
        coordinator?.addCity(name: cityName ?? "",
                                long: long ?? "00",
                                lat: lat ?? "00")
    }
    
    func setGeolocation(name: String, long: String, lat: String) {
        self.cityName = name
        self.long = long
        self.lat = lat
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
    
    private func setWeather() {
        getWeather { [weak self] detailViewModel, hourlyCellViewModel, dailyCellViewModel in
            self?.hourlyCellViewModel = hourlyCellViewModel
            self?.dailyCellViewModel = dailyCellViewModel
            self?.viewController?.displayDetailWeather(detailViewModel)
            self?.viewController?.reloadData()
        }
    }
    
    private func getWeather(completion: @escaping (DetailViewModelProtocol, HourlyCellViewModel, DailyCellViewModel) -> Void) {
        fetcher.getWeather(long: long ?? "00", lat: lat ?? "00") { [weak self] response in
            guard let self = self,
                  let responseDetail = response else { return }
            
            let detailViewModel = self.getDetailViewModel(from: responseDetail)
            
            let responseHourly = responseDetail.hourly
            let hourlyCells = responseHourly.map { responseHourly in self.getHourlyViewModel(from: responseHourly) }
            let preparedHourlyCells = self.configurateHourlyView(hourlyCellViewModel: hourlyCells,
                                                                 response: responseDetail)
            let fixedHourlyCells = Array(preparedHourlyCells.prefix(26))
            let hourlyCellViewModel = HourlyCellViewModel(cells: fixedHourlyCells)
            
            let responseDaily = responseDetail.daily
            let dailyCells = responseDaily.map { responseDaily in self.getDailyViewModel(from: responseDaily) }
            let dailyCellViewModel = DailyCellViewModel(cells: dailyCells)
            
            completion(detailViewModel, hourlyCellViewModel, dailyCellViewModel)
        }
    }
    
    private func getDetailViewModel(from response: WeatherResponse) -> DetailViewModelProtocol {
        let current = response.current
        let daily = response.daily.first
        let descriptions = response.current.weather.map { weather in weather.descriptionStr }
        let description = descriptions[0]
        
        self.timezoneOffset = response.timezoneOffset
        self.temp = current.tempCelsiusString
        self.description = description
        
        return DetailViewModel(location: cityName ?? "--",
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
    
    private func getHourlyViewModel(from response: WeatherHourly) -> HourlyCellViewModelProtocol {
        let weather = response.weather
        let icon = weather.map { weather in weather.icon }
        
        return HourlyCellViewModel.HourlyCell(dtHourly: response.dtDate.formateToHours(timezoneOffset: timezoneOffset ?? 0),
                                              temp: response.tempCelsiusString,
                                              weatherIcon: icon[0])
    }
    
    private func getDailyViewModel(from response: WeatherDaily) -> DailyCellViewModelProtocol {
        let weather = response.weather
        let icon = weather.map { weather in weather.icon }
        
        return DailyCellViewModel.DailyCell(dtDaily: response.dtDate.formateToDays(),
                                            weatherIcon: icon[0],
                                            tempMax: response.temp.maxCelsiusString,
                                            tempMin: response.temp.minCelsiusString)
    }
    
    private func configurateHourlyView(hourlyCellViewModel: [HourlyCellViewModelProtocol], response: WeatherResponse) -> [HourlyCellViewModelProtocol] {
        
        let sunrise = Int(response.current.sunriseDate.formateToHours(timezoneOffset: response.timezoneOffset))
        let sunset = Int(response.current.sunsetDate.formateToHours(timezoneOffset: response.timezoneOffset))
        
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
    
    deinit {
        print("deinit vm")
    }
}
