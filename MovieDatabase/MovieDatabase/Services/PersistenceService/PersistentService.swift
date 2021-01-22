//
//  PersistentService.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 20/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PersistentService {
    
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
}

extension PersistentService : MoviePersistentServiceProtocol{
    func saveFavoriteMovie(id: Int64?,movieTitle: String?, moviePoster: String?, movieReleaseDate: String?,isFavorite: Bool, moviePosterPath: String?) -> MovieItem {
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let entity = NSEntityDescription.entity(forEntityName: "MovieItem",
                                                in: managedObjectContext)!
        let movie = MovieItem(entity: entity,
                              insertInto: managedObjectContext)
        movie.setValue(id, forKeyPath: "id")
        movie.setValue(movieTitle, forKeyPath: "movieTitle")
        movie.setValue(moviePoster, forKeyPath: "moviePoster")
        movie.setValue(movieReleaseDate, forKeyPath: "movieReleaseDate")
        movie.setValue(isFavorite, forKeyPath: "isFavorite")
        movie.setValue(moviePosterPath, forKeyPath: "moviePosterPath")
        coreDataStack.saveContext()
        return movie
    }
    func fetchAllFavoriteMovies() -> [MovieItem]?{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieItem")
        do {
            let movieItem = try managedObjectContext.fetch(fetchRequest)
            return movieItem as? [MovieItem]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func deleteMovieWithId(_ id:Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieItem")
        fetchRequest.predicate = NSPredicate.init(format: "id==\(id)")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            for object in results {
                managedObjectContext.delete(object)
            }
            coreDataStack.saveContext()
        } catch let error {
            print("Detele all data error :", error)
        }
    }
    
}
