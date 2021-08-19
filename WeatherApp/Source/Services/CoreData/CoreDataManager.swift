//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by admin on 10.08.2021.
//

import CoreData
// TODO: - consider saving only city name and coordinates
final class CoreDataManager {
    
    private enum Keys {
        static let appName = "WeatherApp"
        static let entityCityCell = "CityCell"
        
        static let id = "id"
        static let name = "name"
        static let lon = "lon"
        static let lat = "lat"
        static let temp = "temp"
        static let descript = "descript"
        static let dateAdded = "dateAdded"
    }
    
    private static var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: Keys.appName)
        persistentContainer.loadPersistentStores { _, error in
            print(error?.localizedDescription ?? "")
        }
        
        return persistentContainer
    }()
    
    var context: NSManagedObjectContext {
        return CoreDataManager.persistentContainer.viewContext
    }
    
    func saveCity(id: String, name: String, lon: String, lat: String, descript: String, temp: String, dateAdded: Date) {
        let city = CityCell(context: context)
        city.setValue(id, forKey: Keys.id)
        city.setValue(name, forKey: Keys.name)
        city.setValue(lon, forKey: Keys.lon)
        city.setValue(lat, forKey: Keys.lat)
        city.setValue(temp, forKey: Keys.temp)
        city.setValue(descript, forKey: Keys.descript)
        city.setValue(dateAdded, forKey: Keys.dateAdded)
        
        do {
            try context.save()
        } catch {
            print(error )
        }
    }
    
    func fetchCityList() -> [CityCell] {
        do {
            let fetchRequest = NSFetchRequest<CityCell>(entityName: Keys.entityCityCell)
            let cities = try context.fetch(fetchRequest)
            return cities
        } catch {
            print(error)
            return []
        }
    }
    
    func removeCity(for indexPath: IndexPath) {
        do {
            let cities = fetchCityList()
            context.delete(cities[indexPath.row])
            try context.save()
        } catch {
            print(error)
        }
    }
}
