//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by admin on 02.08.2021.
//

import Foundation
import UIKit

protocol CityListPresentationLogic {
    func presentCells()
    func setCityCellModel(for indexPath: IndexPath) -> CityCellModelProtocol
    func countCells() -> Int
    func removeCell(for indexPath: IndexPath)
//    func moveRowAt(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    
    func presentSearchVC()
    func presentDetailWeather(_ cityCellModel: CityCellModelProtocol)
}

final class CityListViewModel: CityListPresentationLogic {
    
    weak var viewController: CityListDisplayLogic?
    var coordinator: CityListCoordinator?
    private var fetcher: DataFetcher = WeatherDataFetcher(networkService: NetworkService())
    private let coreDataManager = CoreDataManager()
    
    private var cityCellModel = CityCellModel(cells: [])
    private var cityName: String?
    private var long: String?
    private var lat: String?
    
    func presentSearchVC() {
        coordinator?.startSearchVC()
    }
    
    func presentDetailWeather(_ cityCellModel: CityCellModelProtocol) {
        coordinator?.startDetailVC(cityCellModel)
    }
    
    func presentCells() {
        getCityList()
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
        
    }
    
//    func moveRowAt(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedCell = cityCellModel.cells.remove(at: sourceIndexPath.row)
//        cityCellModel.cells.insert(movedCell, at: destinationIndexPath.row)
//        viewController?.reloadData()
//    }
    
    private func setWeather() {
        
        // TODO: - change logic. current has the wrong behavior
        if cityCellModel.cells.count == 0 {
            return
        } else {
            getWeather { [weak self] cityCellModel in
                
                self?.cityCellModel = cityCellModel
                self?.viewController?.reloadData()
            }
        }
    }
    
    private func getWeather(completion: @escaping (CityCellModel) -> Void) {
        
        // TODO: - cycle for in
        fetcher.getWeather(long: long ?? "00", lat: lat ?? "00") { [weak self] response in
            guard let self = self,
                  let response = response else { return }
            
            let cellModel = self.getCityCellModel(from: response)
            let cityCellModel = CityCellModel(cells: [cellModel])
            
            completion(cityCellModel)
        }
    }
    
    private func getCityCellModel(from response: WeatherResponse) -> CityCellModelProtocol {
        let descriptions = response.current.weather.map { weather in weather.descriptionStr }
        let description = descriptions[0]
        
        return CityCellModel.CityCell(name: cityName ?? "",
                                      description: description,
                                      temp: response.current.tempCelsiusString + "º",
                                      lat: lat ?? "00",
                                      long: long ?? "00")
    }
    
    private func getCityList() {
        let entity = coreDataManager.fetchCityList()
        let cities = entity.map { [unowned self] city in self.fetchCityList(from: city) }
        let cityCellModel = CityCellModel(cells: cities)
        self.cityCellModel = cityCellModel
        viewController?.reloadData()
    }
    
    private func fetchCityList(from entity: CityCell) -> CityCellModelProtocol {
        let temp = entity.temp ?? ""
        
        return CityCellModel.CityCell(name: entity.name ?? "",
                                      description: entity.descript ?? "",
                                      temp: temp + "º",
                                      lat: entity.lat ?? "",
                                      long: entity.long ?? "")
    }
}
