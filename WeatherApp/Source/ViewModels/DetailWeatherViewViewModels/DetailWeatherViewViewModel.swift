//
//  DetailWeatherViewViewModel.swift
//  WeatherApp
//
//  Created by admin on 21.07.2021.
//

import UIKit
import Foundation

protocol DetailWeatherRouting {
    func goToCityList()
    func dismissVC(viewController: UIViewController)
}

protocol DetailWeatherPresentationLogic: DetailWeatherRouting {
    func presentWeather()
    func setHourlyViewModel(for indexPath: IndexPath) -> HourlyCellViewModelProtocol
    func setDailyViewModel(for indexPath: IndexPath) -> DailyCellViewModelProtocol
    func countHourlyCells() -> Int
    func countDailyCells() -> Int
    func addCityToCityList()
}

protocol DetailWeatherDataFlow: AnyObject {
    func goToCityList()
    func dismissDetailVC(viewController: UIViewController)
    func addCity(id: String, name: String, lon: String, lat: String)
}

final class DetailWeatherViewViewModel: DetailWeatherPresentationLogic {
    
    // MARK: - Properties
    
    weak var viewController: DetailViewDisplayLogic?
    weak var dataFlow: DetailWeatherDataFlow?
    
    private let fetcher: WeatherDataFetcherProtocol
    private let databaseService: CityListDatabaseServiceProtocol
    
    private var hourlyCellViewModel = HourlyCellViewModel(cells: [])
    private var dailyCellViewModel = DailyCellViewModel(cells: [])
    
    private var temp: String?
    private var description: String?
    private var timezoneOffset: Int?
    
    var id: String?
    var cityName: String?
    var lon: String?
    var lat: String?
    
    // MARK: - Init
    
    init(fetcher: WeatherDataFetcherProtocol = WeatherDataFetcher(networkService: NetworkService()),
         databaseService: CityListDatabaseServiceProtocol = CityListDatabaseService()) {
        self.fetcher = fetcher
        self.databaseService = databaseService
    }
    
    // MARK: - Routing
    
    func goToCityList() {
        dataFlow?.goToCityList()
    }
    
    func dismissVC(viewController: UIViewController) {
        dataFlow?.dismissDetailVC(viewController: viewController)
    }
    
    // MARK: - Presentation logic
    
    func presentWeather() {
        displayWeather()
    }
    
    func setGeolocation(id: String, name: String, lon: String, lat: String) {
        self.id = id
        self.cityName = name
        self.lon = lon
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
    
    func addCityToCityList() {
        let cityCellModel = createCityCellModel()
        
        databaseService.add(cityCellModel: cityCellModel)
        
        dataFlow?.addCity(id: id ?? "",
                          name: cityName ?? "",
                          lon: lon ?? "00",
                          lat: lat ?? "00")
    }
    
    // MARK: - Private methods
    
    private func displayWeather() {
        fetchWeather { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success((let detailViewModel, let hourlyCellViewModel, let dailyCellViewModel)):
                self.hourlyCellViewModel = hourlyCellViewModel
                self.dailyCellViewModel = dailyCellViewModel
                self.viewController?.display(detailViewModel: detailViewModel)
                self.viewController?.reloadData()
                
            case .failure(let error):
                guard let viewController = self.viewController as? DetailWeatherViewController else { return }
                
                viewController.locationLabel.text = self.cityName
                viewController.showToastMessage(message: error.localizedDescription)
            }
        }
    }
    
    private func fetchWeather(completion: @escaping RequestResult<ResponseModels>) {
        fetcher.fetchWeather(lon: lon ?? "00", lat: lat ?? "00") { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let responseDetail = response
                let detailViewModel = self.createDetailViewModel(from: responseDetail)
                
                let responseHourly = responseDetail.hourly
                let hourlyCells = responseHourly.map { responseHourly in self.createHourlyViewModel(from: responseHourly) }
                let preparedHourlyCells = self.configurateHourlyViewModel(hourlyCellViewModel: hourlyCells,
                                                                          response: responseDetail)
                let fixedHourlyCells = Array(preparedHourlyCells.prefix(26))
                let hourlyCellViewModel = HourlyCellViewModel(cells: fixedHourlyCells)
                
                let responseDaily = responseDetail.daily
                let dailyCells = responseDaily.map { responseDaily in self.createDailyViewModel(from: responseDaily) }
                let dailyCellViewModel = DailyCellViewModel(cells: dailyCells)
                
                completion(.success((detailViewModel, hourlyCellViewModel, dailyCellViewModel)))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func createDetailViewModel(from response: WeatherResponse) -> DetailViewModelProtocol {
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
    
    private func createHourlyViewModel(from response: WeatherHourly) -> HourlyCellViewModelProtocol {
        let weather = response.weather
        let icon = weather.map { weather in weather.icon }
        
        return HourlyCellViewModel.HourlyCell(dtHourly: response.dtDate.formateToHours(timezoneOffset: timezoneOffset ?? 0),
                                              temp: response.tempCelsiusString,
                                              weatherIcon: icon[0])
    }
    
    private func createDailyViewModel(from response: WeatherDaily) -> DailyCellViewModelProtocol {
        let weather = response.weather
        let icon = weather.map { weather in weather.icon }
        
        return DailyCellViewModel.DailyCell(dtDaily: response.dtDate.formateToDays(),
                                            weatherIcon: icon[0],
                                            tempMax: response.temp.maxCelsiusString,
                                            tempMin: response.temp.minCelsiusString)
    }
    
    private func configurateHourlyViewModel(hourlyCellViewModel: [HourlyCellViewModelProtocol], response: WeatherResponse) -> [HourlyCellViewModelProtocol] {
        
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
    
    private func createCityCellModel() -> CityCellModelProtocol {
        let date = NSDate() as Date
        
        return CityListModel.CityCellModel(id: id ?? "",
                                           name: cityName ?? "",
                                           description: description ?? "",
                                           temp: temp ?? "",
                                           lat: lat ?? "00",
                                           lon: lon ?? "00",
                                           dateAdded: date)
    }
}
