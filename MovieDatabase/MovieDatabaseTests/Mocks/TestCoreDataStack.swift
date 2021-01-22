//
//  TestCoreDataStack.swift
//  MovieDatabaseTests
//
//  Created by Sumit Kumar on 22/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import Foundation
import MovieDatabase
import CoreData
class TestCoreDataStack: CoreDataStack {
  override init() {
    super.init()

    let persistentStoreDescription = NSPersistentStoreDescription()
    persistentStoreDescription.type = NSInMemoryStoreType

    let container = NSPersistentContainer(
      name: CoreDataStack.modelName,
      managedObjectModel: CoreDataStack.model)
    container.persistentStoreDescriptions = [persistentStoreDescription]

    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    storeContainer = container
  }
}
