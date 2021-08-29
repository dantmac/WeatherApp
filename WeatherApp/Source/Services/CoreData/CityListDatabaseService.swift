//
//  CityListDatabaseService.swift
//  WeatherApp
//
//  Created by admin on 21.08.2021.
//

import Foundation

protocol CityListDatabaseServiceProtocol {
    func add(cityCellModel: CityCellModelProtocol)
    func get() -> [CityCellPersistentModel]
    func delete(for indexPath: IndexPath)
}

struct CityListDatabaseService: CityListDatabaseServiceProtocol {
    
    private enum Keys {
        static let id = "id"
        static let name = "name"
        static let lon = "lon"
        static let lat = "lat"
        static let temp = "temp"
        static let descript = "descript"
        static let dateAdded = "dateAdded"
    }
    
    // MARK: - Properties
    
    private let coreDataManager: CoreDataManager
    
    // MARK: - Init
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - Database Service
    
    func add(cityCellModel: CityCellModelProtocol) {
        let city = CityCellPersistentModel(context: coreDataManager.context)
        
        city.setValue(cityCellModel.id, forKey: Keys.id)
        city.setValue(cityCellModel.name, forKey: Keys.name)
        city.setValue(cityCellModel.lon, forKey: Keys.lon)
        city.setValue(cityCellModel.lat, forKey: Keys.lat)
        city.setValue(cityCellModel.temp, forKey: Keys.temp)
        city.setValue(cityCellModel.description, forKey: Keys.descript)
        city.setValue(cityCellModel.dateAdded, forKey: Keys.dateAdded)
        
        coreDataManager.save()
    }
    
    
    func delete(for indexPath: IndexPath) {
        let cities = get()
        
        do {
            coreDataManager.context.delete(cities[indexPath.row])
            try coreDataManager.context.save()
        } catch {
            print(error)
        }
    }
    
    func get() -> [CityCellPersistentModel] {
        return coreDataManager.get()
    }
}
