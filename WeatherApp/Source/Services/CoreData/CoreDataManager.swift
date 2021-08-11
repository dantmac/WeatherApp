//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by admin on 10.08.2021.
//

import CoreData
// TODO: - consider saving only city name and coordinates
final class CoreDataManager {
    private static var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "WeatherApp")
        persistentContainer.loadPersistentStores { _, error in
            print(error?.localizedDescription ?? "")
        }
        
        return persistentContainer
    }()
    
    var context: NSManagedObjectContext {
        return CoreDataManager.persistentContainer.viewContext
    }
    
    func saveCity(name: String, long: String, lat: String, descript: String, temp: String, dateAdded: Date) {
        let city = CityCell(context: context)
        city.setValue(name, forKey: "name")
        city.setValue(long, forKey: "long")
        city.setValue(lat, forKey: "lat")
        city.setValue(temp, forKey: "temp")
        city.setValue(descript, forKey: "descript")
        city.setValue(dateAdded, forKey: "dateAdded")
        
        do {
            try context.save()
        } catch {
            print(error )
        }
    }
    
    func fetchCityList() -> [CityCell] {
        do {
            let fetchRequest = NSFetchRequest<CityCell>(entityName: "CityCell")
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
