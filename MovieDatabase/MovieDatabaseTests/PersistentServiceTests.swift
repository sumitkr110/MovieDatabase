//
//  PersistentServiceTests.swift
//  MovieDatabaseTests
//
//  Created by Sumit Kumar on 22/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import XCTest
@testable import MovieDatabase
class PersistentServiceTests: XCTestCase {
    // swiftlint:disable implicitly_unwrapped_optional
    var persistentService: MoviePersistentServiceProtocol!
    var coreDataStack: TestCoreDataStack!
    // swiftlint:enable implicitly_unwrapped_optional
    
    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        persistentService = PersistentService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
    }
    func testAddMovie() {
        let movie = persistentService.saveFavoriteMovie(id: 10, movieTitle: "Rock", moviePoster: "/moviePoster", movieReleaseDate: "01/01/2020", isFavorite: false, moviePosterPath: Constant.imageBaseUrl + "/moviePoster")

      XCTAssertNotNil(movie, "Movie should not be nil")
      XCTAssertTrue(movie.id == 10)
      XCTAssertTrue(movie.movieTitle == "Rock")
      XCTAssertTrue(movie.moviePoster == "/moviePoster")
      XCTAssertTrue(movie.movieReleaseDate == "01/01/2020")
      XCTAssertTrue(((movie.moviePosterPath?.contains(Constant.imageBaseUrl)) != nil))
      XCTAssertNotNil(movie.isFavorite, "isFavorite should not be nil")
      XCTAssertNotNil(movie.id, "id should not be nil")
    }

    func testRootContextIsSavedAfterAddingMovie() {
      let derivedContext = coreDataStack.newDerivedContext()
      persistentService = PersistentService(managedObjectContext: derivedContext, coreDataStack: coreDataStack)

      expectation(
        forNotification: .NSManagedObjectContextDidSave,
        object: coreDataStack.mainContext) { _ in
          return true
      }
      derivedContext.perform {
        let movie = self.persistentService.saveFavoriteMovie(id: 10, movieTitle: "Rock", moviePoster: "/moviePoster", movieReleaseDate: "01/01/2020", isFavorite: false, moviePosterPath: Constant.imageBaseUrl + "/moviePoster")

        XCTAssertNotNil(movie)
      }
      waitForExpectations(timeout: 2.0) { error in
        XCTAssertNil(error, "Save did not occur")
      }
    }

    func testFetchMovies() {
      let newMovie = persistentService.saveFavoriteMovie(id: 10, movieTitle: "Rock", moviePoster: "/moviePoster", movieReleaseDate: "01/01/2020", isFavorite: false, moviePosterPath: Constant.imageBaseUrl + "/moviePoster")
      let fetchMovies = persistentService.fetchAllFavoriteMovies()
      XCTAssertNotNil(fetchMovies)
      XCTAssertTrue(fetchMovies?.count == 1)
      XCTAssertTrue(newMovie.id == fetchMovies?.first?.id)
    }

    func testDeleteReport() {
        let newMovie = persistentService.saveFavoriteMovie(id: 10, movieTitle: "Rock", moviePoster: "/moviePoster", movieReleaseDate: "01/01/2020", isFavorite: false, moviePosterPath: Constant.imageBaseUrl + "/moviePoster")

      var fetchMovies = persistentService.fetchAllFavoriteMovies()
      XCTAssertTrue(fetchMovies?.count == 1)
      XCTAssertTrue(newMovie.id == fetchMovies?.first?.id)
      persistentService.deleteMovieWithId(Int(fetchMovies!.first!.id))
      fetchMovies = persistentService.fetchAllFavoriteMovies()
      XCTAssertTrue(fetchMovies?.isEmpty ?? false)
    }
    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        persistentService = nil
    }
    
}
