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
    func removeCell(for indexPath: IndexPath)
    //    func moveRowAt(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    
    func presentSearchVC()
    func presentDetailWeather(_ cityCellModel: CityCellModelProtocol, from indexPath: IndexPath)
}

// TODO: - consider following Interface Segregation principle

final class CityListViewModel: CityListPresentationLogic {
    
    weak var viewController: CityListDisplayLogic?
    weak var coordinator: AppCoordinator?
    
    private var fetcher: DataFetcher = WeatherDataFetcher(networkService: NetworkService())
    private let coreDataManager = CoreDataManager()
    
    private var cityCellModel = CityCellModel(cells: [])
    private var cityName: String?
    private var long: String?
    private var lat: String?
    
    func presentSearchVC() {
        coordinator?.startSearchVC()
    }
    
    func presentDetailWeather(_ cityCellModel: CityCellModelProtocol, from indexPath: IndexPath) {
        coordinator?.startPageVC(cityCellModel, from: indexPath)
    }
    
    func presentCityList() {
        getCityList()
        setCityList()
    }
    
    func setCityCellModel(for indexPath: IndexPath) -> CityCellModelProtocol {
        let cellViewModel = cityCellModel.cells[indexPath.row]
        return cellViewModel
    }
    
    func countCells() -> Int {
        return cityCellModel.cells.count
    }
    
    func addCity(name: String, long: String, lat: String) {
        self.cityName = name
        self.long = long
        self.lat = lat
        
        fetcher.getWeather(long: long, lat: lat) { [weak self] response in
            guard let self = self,
                  let response = response else { return }
            
            let cellModel = self.getCityCellModel(from: response)
            
            self.cityCellModel.cells.append(cellModel)
            self.viewController?.reloadData()
        }
    }
    
    func removeCell(for indexPath: IndexPath) {
        coreDataManager.removeCity(for: indexPath)
        cityCellModel.cells.remove(at: indexPath.row)
        coordinator?.removeVC(at: indexPath)
    }
    
    //    func moveRowAt(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    //        let movedCell = cityCellModel.cells.remove(at: sourceIndexPath.row)
    //        cityCellModel.cells.insert(movedCell, at: destinationIndexPath.row)
    //        viewController?.reloadData()
    //    }
    
    private func setCityList() {
        if cityCellModel.cells.isEmpty {
            coordinator?.startSearchVC()
        } else {
            updateWeather { [weak self] updatedModel in
                guard let self = self else { return }
                
                for (i, j) in self.cityCellModel.cells.enumerated() {
                    if j.dateAdded == updatedModel.dateAdded {
                        self.cityCellModel.cells.remove(at: i)
                        self.cityCellModel.cells.insert(updatedModel, at: i)
                    }
                }
                
                self.viewController?.reloadData()
            }
        }
    }
    
    private func updateWeather(completion: @escaping (CityCellModelProtocol) -> Void) {
        var updatedCity = CityCellModel.CityCell(name: "",
                                                 description: "",
                                                 temp: "",
                                                 lat: "",
                                                 long: "",
                                                 dateAdded: Date())
        
        for city in cityCellModel.cells {
            fetcher.getWeather(long: city.long, lat: city.lat) { response in
                guard let response = response else { return }
                
                let descriptions = response.current.weather.map { weather in weather.descriptionStr }
                let description = descriptions[0]
                let temp = response.current.tempCelsiusString
                
                updatedCity.name = city.name
                updatedCity.description = description
                updatedCity.lat = city.lat
                updatedCity.long = city.long
                updatedCity.temp = temp + "º"
                updatedCity.dateAdded = city.dateAdded
                
                completion(updatedCity)
            }
        }
    }
    
    private func getCityCellModel(from response: WeatherResponse) -> CityCellModelProtocol {
        let descriptions = response.current.weather.map { weather in weather.descriptionStr }
        let description = descriptions[0]
        
        return CityCellModel.CityCell(name: cityName ?? "",
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
        
        coordinator?.preinstallVC(cityCellModel)
    }
    
    private func fetchCityList(from entity: CityCell) -> CityCellModelProtocol {
        let temp = (entity.temp ?? "") + "º"
        
        return CityCellModel.CityCell(name: entity.name ?? "",
                                      description: entity.descript ?? "",
                                      temp: temp,
                                      lat: entity.lat ?? "",
                                      long: entity.long ?? "",
                                      dateAdded: entity.dateAdded ?? Date())
    }
}
