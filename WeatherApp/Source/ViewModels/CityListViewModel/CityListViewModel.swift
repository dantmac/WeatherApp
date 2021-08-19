//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by admin on 02.08.2021.
//

import Foundation
import UIKit

protocol CityListPresentationLogic {
    func presentCityList()
    func setCityCellModel(for indexPath: IndexPath) -> CityCellModelProtocol
    func countCells() -> Int
    func removeCity(for indexPath: IndexPath)
    
    func refreshCityList()
    func presentSearchVC()
    func presentDetailWeather(_ cityCellModel: CityCellModelProtocol, from indexPath: IndexPath)
}

final class CityListViewModel: CityListPresentationLogic {
    
    // MARK: - Properties
    
    weak var viewController: CityListDisplayLogic?
    weak var coordinator: AppCoordinator?
    
    private var fetcher: DataFetcher = WeatherDataFetcher(networkService: NetworkService())
    private let coreDataManager = CoreDataManager()
    
    private var cityCellModel = CityCellModel(cells: [])
    private var id: String?
    private var cityName: String?
    private var long: String?
    private var lat: String?
    
    // MARK: - Business logic
    
    func presentCityList() {
        getCityList()
        updateCityList()
        
        coordinator?.preinstallDetailVC(cityCellModel)
    }
    
    func presentDetailWeather(_ cityCellModel: CityCellModelProtocol, from indexPath: IndexPath) {
        coordinator?.startPageVC(cityCellModel, from: indexPath)
    }
    
    func presentSearchVC() {
        coordinator?.startSearchVC()
    }
    
    func refreshCityList() {
        updateCityList()
    }
    
    func setCityCellModel(for indexPath: IndexPath) -> CityCellModelProtocol {
        let cellViewModel = cityCellModel.cells[indexPath.row]
        return cellViewModel
    }
    
    func countCells() -> Int {
        return cityCellModel.cells.count
    }
    
    func addCity(id: String, name: String, long: String, lat: String) {
        self.id = id
        self.cityName = name
        self.long = long
        self.lat = lat
        
        fetcher.fetchWeather(long: long, lat: lat) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let cellModel = self.getCityCellModel(from: response)
                self.cityCellModel.cells.append(cellModel)
                self.viewController?.reloadData()
                
            case .failure(let error):
                guard let viewController = self.viewController as? CityListViewController else { return }
                
                Toast.show(message: error.localizedDescription, controller: viewController)
            }
        }
    }
    
    func removeCity(for indexPath: IndexPath) {
        coreDataManager.removeCity(for: indexPath)
        cityCellModel.cells.remove(at: indexPath.row)
        coordinator?.removeDetailVC(at: indexPath)
        viewController?.reloadData()
    }
    
    func checkForExistenceCity(placeID: String) -> Bool {
        var checker = false
        
        for city in cityCellModel.cells {
            
            if city.id == placeID {
                checker = true
            }
        }
        
        return checker
    }
    
    // MARK: - Private methods
    
    private func updateCityList() {
        if cityCellModel.cells.isEmpty {
            coordinator?.startSearchVC()
        } else {
            updateWeather { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success(let updatedModel):
                    for (i, j) in self.cityCellModel.cells.enumerated() {
                        if j.dateAdded == updatedModel.dateAdded {
                            self.cityCellModel.cells.remove(at: i)
                            self.cityCellModel.cells.insert(updatedModel, at: i)
                        }
                    }
                    
                    self.viewController?.reloadData()
                    
                case .failure(let error):
                    guard let viewController = self.viewController as? CityListViewController else { return }
                    
                    Toast.show(message: error.localizedDescription, controller: viewController)
                }
            }
        }
    }
    
    private func updateWeather(completion: @escaping RequestResult<CityCellModelProtocol>) {
        var updatedCity = CityCellModel.CityCell(id: "",
                                                 name: "",
                                                 description: "",
                                                 temp: "",
                                                 lat: "",
                                                 long: "",
                                                 dateAdded: Date())
        
        for city in cityCellModel.cells {
            fetcher.fetchWeather(long: city.long, lat: city.lat) { result in
                
                switch result {
                case .success(let response):
                    
                    let descriptions = response.current.weather.map { weather in weather.descriptionStr }
                    let description = descriptions[0]
                    let temp = response.current.tempCelsiusString
                    
                    updatedCity.id = city.id
                    updatedCity.name = city.name
                    updatedCity.description = description
                    updatedCity.lat = city.lat
                    updatedCity.long = city.long
                    updatedCity.temp = temp + "º"
                    updatedCity.dateAdded = city.dateAdded
                    
                    completion(.success(updatedCity))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func getCityCellModel(from response: WeatherResponse) -> CityCellModelProtocol {
        let descriptions = response.current.weather.map { weather in weather.descriptionStr }
        let description = descriptions[0]
        
        return CityCellModel.CityCell(id: id ?? "",
                                      name: cityName ?? "",
                                      description: description,
                                      temp: response.current.tempCelsiusString + "º",
                                      lat: lat ?? "00",
                                      long: long ?? "00",
                                      dateAdded: Date())
    }
    
    private func getCityList() {
        let entity = coreDataManager.fetchCityList()
        let cities = entity.map { [unowned self] city in self.fetchCityList(from: city) }
        let cityCellModel = CityCellModel(cells: cities)
        self.cityCellModel = cityCellModel
    }
    
    private func fetchCityList(from entity: CityCell) -> CityCellModelProtocol {
        let temp = (entity.temp ?? "") + "º"
        
        return CityCellModel.CityCell(id: entity.id ?? "",
                                      name: entity.name ?? "",
                                      description: entity.descript ?? "",
                                      temp: temp,
                                      lat: entity.lat ?? "",
                                      long: entity.long ?? "",
                                      dateAdded: entity.dateAdded ?? Date())
    }
}
