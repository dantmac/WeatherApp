//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by admin on 10.08.2021.
//

import CoreData

struct CoreDataManager {
   
    // MARK: - Properties
    
    static let appName = "WeatherApp"
    
    static let shared = CoreDataManager()
    
    private static var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: CoreDataManager.appName)
        persistentContainer.loadPersistentStores { _, error in
            print(error?.localizedDescription ?? "")
        }
        
        return persistentContainer
    }()
    
    var context: NSManagedObjectContext {
        return CoreDataManager.persistentContainer.viewContext
    }
    
    // MARK: -  Menaging
    
    func get<T: NSManagedObject>() -> [T] {
        do {
            let fetchRequest = NSFetchRequest<T>(entityName: "\(T.self)")
            return try context.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
