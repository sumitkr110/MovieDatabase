//
//  MovieViewModelTests.swift
//  MovieDatabaseTests
//
//  Created by Sumit Kumar on 22/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import XCTest
@testable import MovieDatabase
class MovieViewModelTests: XCTestCase {
    
    var movieViewModel : MovieViewModel!
    var persistentService: MoviePersistentServiceProtocol!
    var coreDataStack: TestCoreDataStack!
    var apiService : MovieAPIServiceProtocol!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiService = MockAPIServiceClient()
        coreDataStack = TestCoreDataStack()
        persistentService = PersistentService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
        movieViewModel = MovieViewModel.init(withAPIService: apiService, andPersistentService: persistentService)
        fetchNowPlayingMovieList()
    }
    func fetchNowPlayingMovieList(){
        apiService.getNowPlayingList{[weak self] result in
            switch result{
            case .success(let nowPlayingDataModel):
                self?.movieViewModel.buildItemViewModelFrom(nowPlayingVM: nowPlayingDataModel)
                XCTAssertNotNil(self?.movieViewModel.nowPlayingMovieList)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testFetchFavoriteMovieList(){
        let movie = persistentService.saveFavoriteMovie(id: 10, movieTitle: "Rock", moviePoster: "/moviePoster", movieReleaseDate: "01/01/2020", isFavorite: false, moviePosterPath: Constant.imageBaseUrl + "/moviePoster")
        
        if let favoriteMovies = self.persistentService?.fetchAllFavoriteMovies(){
            self.movieViewModel.favoriteMovieList.value = favoriteMovies
        }
        XCTAssertNotNil(self.movieViewModel.favoriteMovieList.value)
        XCTAssertTrue(self.movieViewModel.favoriteMovieList.value.count == 1)
        XCTAssertTrue(movie.id == self.movieViewModel.favoriteMovieList.value.first!.id)
    }
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
}
