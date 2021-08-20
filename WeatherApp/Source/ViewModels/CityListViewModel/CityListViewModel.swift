//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by admin on 02.08.2021.
//

import Foundation
import UIKit

protocol CityListRouting {
    func presentCityList()
    func presentSearchVC()
    func presentDetailWeather(_ cityCellModel: CityCellModelProtocol, from indexPath: IndexPath)
}

protocol CityListPresentationLogic: CityListRouting {
    func setCityCellModel(for indexPath: IndexPath) -> CityCellModelProtocol
    func updateCityList()
    func countCities() -> Int
    func removeCity(for indexPath: IndexPath)
}

protocol CityListDataFlow: AnyObject {
    func startSearchVC()
    func startPageVC(_ cityCellModel: CityCellModelProtocol, cityListModel: CityListModel, from indexPath: IndexPath)
}

final class CityListViewModel: CityListPresentationLogic {
    
    // MARK: - Properties
    
    weak var viewController: CityListDisplayLogic?
    weak var dataFlow: CityListDataFlow?
    
    private var fetcher: WeatherDataFetcherProtocol = WeatherDataFetcher(networkService: NetworkService())
    private let coreDataManager = CoreDataManager()
    
    private var cityListModel = CityListModel(cells: [])
    private var id: String?
    private var cityName: String?
    private var lon: String?
    private var lat: String?
    
    // MARK: - Routing Logic
    
    func presentCityList() {
        getCityListFromDatabase()
        updateCityList()
        
//        dataFlow?.preinstallDetailVC(cityListModel)
    }
    
    func presentDetailWeather(_ cityCellModel: CityCellModelProtocol, from indexPath: IndexPath) {
        dataFlow?.startPageVC(cityCellModel, cityListModel: cityListModel, from: indexPath)
    }
    
    func presentSearchVC() {
        dataFlow?.startSearchVC()
    }
   
    // MARK: - Presentation Logic
    
    func setCityCellModel(for indexPath: IndexPath) -> CityCellModelProtocol {
        let cellViewModel = cityListModel.cells[indexPath.row]
        return cellViewModel
    }
    
    func countCities() -> Int {
        return cityListModel.cells.count
    }
    
    func removeCity(for indexPath: IndexPath) {
        coreDataManager.removeCity(for: indexPath)
        cityListModel.cells.remove(at: indexPath.row)
        viewController?.reloadData()
    }
    
    func updateCityList() {
        if cityListModel.cells.isEmpty {
            dataFlow?.startSearchVC()
        } else {
            updateWeather { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let updatedModel):
                    for (i, j) in self.cityListModel.cells.enumerated() {
                        if j.dateAdded == updatedModel.dateAdded {
                            self.cityListModel.cells.remove(at: i)
                            self.cityListModel.cells.insert(updatedModel, at: i)
                        }
                    }
                    
                    self.viewController?.reloadData()
                    
                case .failure(let error):
                    self.viewController?.showToastMessage(message: error.localizedDescription)
                }
            }
        }
    }
    
    func addCity(id: String, name: String, lon: String, lat: String) {
        self.id = id
        self.cityName = name
        self.lon = lon
        self.lat = lat
        
        fetcher.fetchWeather(lon: lon, lat: lat) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let cellModel = self.createCityCellModel(from: response)
                self.cityListModel.cells.append(cellModel)
                self.viewController?.reloadData()
                
            case .failure(let error):
                self.viewController?.showToastMessage(message: error.localizedDescription)
            }
        }
    }
    
    func checkForExistenceCity(placeID: String) -> Bool {
        let isCityExists = cityListModel.cells.filter { $0.id == placeID }.count != 0
        
        return isCityExists
    }
    
    // MARK: - Private methods
    
    private func updateWeather(completion: @escaping RequestResult<CityCellModelProtocol>) {
        var updatedCity = CityListModel.CityCellModel(id: "",
                                                 name: "",
                                                 description: "",
                                                 temp: "",
                                                 lat: "",
                                                 lon: "",
                                                 dateAdded: Date())
        
        for city in cityListModel.cells {
            fetcher.fetchWeather(lon: city.lon, lat: city.lat) { [weak self] result in
                
                guard self != nil else { return }
                
                switch result {
                case .success(let response):
                    
                    let descriptions = response.current.weather.map { weather in weather.descriptionStr }
                    let description = descriptions[0]
                    let temp = response.current.tempCelsiusString
                    
                    updatedCity.id = city.id
                    updatedCity.name = city.name
                    updatedCity.description = description
                    updatedCity.lat = city.lat
                    updatedCity.lon = city.lon
                    updatedCity.temp = temp + "º"
                    updatedCity.dateAdded = city.dateAdded
                    
                    completion(.success(updatedCity))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func getCityListFromDatabase() {
        let entity = coreDataManager.fetchCityList()
        let cities = entity.map { city in createCityCellModel(from: city) }
        let cityCellModel = CityListModel(cells: cities)
        self.cityListModel = cityCellModel
    }
    
    private func createCityCellModel(from response: WeatherResponse) -> CityCellModelProtocol {
        let descriptions = response.current.weather.map { weather in weather.descriptionStr }
        let description = descriptions[0]
        
        return CityListModel.CityCellModel(id: id ?? "",
                                      name: cityName ?? "",
                                      description: description,
                                      temp: response.current.tempCelsiusString + "º",
                                      lat: lat ?? "00",
                                      lon: lon ?? "00",
                                      dateAdded: Date())
    }
    
    private func createCityCellModel(from entity: CityCellPersistentModel) -> CityCellModelProtocol {
        let temp = (entity.temp ?? "") + "º"
        
        return CityListModel.CityCellModel(id: entity.id ?? "",
                                      name: entity.name ?? "",
                                      description: entity.descript ?? "",
                                      temp: temp,
                                      lat: entity.lat ?? "",
                                      lon: entity.lon ?? "",
                                      dateAdded: entity.dateAdded ?? Date())
    }
}
