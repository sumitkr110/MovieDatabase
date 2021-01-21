//
//  CoreDataManager.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 20/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PersistentManager {
    
    static let sharedManager = PersistentManager()
    private init() {}
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieDatabase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension PersistentManager : MoviePersistentServiceProtocol{
    
    func saveFavoriteMovie(id: Int64?,movieTitle: String?, moviePoster: String?, movieReleaseDate: String?,isFavorite: Bool, moviePosterPath: String?) {
        let managedContext = PersistentManager.sharedManager.persistentContainer.viewContext
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let entity = NSEntityDescription.entity(forEntityName: "MovieItem",
                                                in: managedContext)!
        let movie = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        movie.setValue(id, forKeyPath: "id")
        movie.setValue(movieTitle, forKeyPath: "movieTitle")
        movie.setValue(moviePoster, forKeyPath: "moviePoster")
        movie.setValue(movieReleaseDate, forKeyPath: "movieReleaseDate")
        movie.setValue(isFavorite, forKeyPath: "isFavorite")
        movie.setValue(moviePosterPath, forKeyPath: "moviePosterPath")
        saveContext()
    }
    func fetchAllFavoriteMovies() -> [MovieItem]?{
        let managedContext = PersistentManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieItem")
        do {
            let movieItem = try managedContext.fetch(fetchRequest)
            return movieItem as? [MovieItem]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
    }
    func deleteMovieWithId(_ id:Int) {
        let managedContext = PersistentManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieItem")
        fetchRequest.predicate = NSPredicate.init(format: "id==\(id)")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                managedContext.delete(object)
            }
            saveContext()
        } catch let error {
            print("Detele all data error :", error)
        }
    }
    
}
