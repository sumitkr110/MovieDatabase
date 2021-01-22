//
//  HomeViewModel.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 18/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import Foundation
import UIKit

class MovieViewModel {
    var nowPlayingMovieList =  Observable<[MovieItemVM]>(value: [])
    var favoriteMovieList =  Observable<[MovieItem]>(value: [])
    var isLoading = Observable<Bool> (value: true)
    var error = Observable<APIServiceError?>(value: nil)
    var apiService : MovieAPIServiceProtocol?
    var persistentService : MoviePersistentServiceProtocol?
    init(withAPIService apiService:MovieAPIServiceProtocol?, andPersistentService persistentService:MoviePersistentServiceProtocol?) {
        self.apiService = apiService
        self.persistentService = persistentService
    }
    func fetchFavoriteMovieList(){
        if let favoriteMovies = self.persistentService?.fetchAllFavoriteMovies(){
            favoriteMovieList.value = favoriteMovies
        }
    }
    func fetchNowPlayingMovieList(){
        self.apiService?.getNowPlayingList{[weak self] result in
            switch result{
            case .success(let nowPlayingDataModel):
                self?.buildItemViewModelFrom(nowPlayingVM: nowPlayingDataModel)
                self?.isLoading.value = false
            case .failure(let error):
                self?.isLoading.value = false
                self?.error.value = error
            }
        }
    }
    func buildItemViewModelFrom(nowPlayingVM:MovieDataModel) {
        if let movies = nowPlayingVM.results{
            for movie in movies {
                let movieItemVM = MovieItemVM.init(movieId: movie.id, movieTitle: movie.title, moviePoster: movie.posterPath, movieReleaseDate: movie.releaseDate, isFavorite: checkForFavoriteMovies(movie.id!))
                nowPlayingMovieList.value.append(movieItemVM)
            }
        }
    }
    private func checkForFavoriteMovies(_ movieId: Int) -> Bool{
        var isFavorite = false
        if let favoriteMovies = self.persistentService?.fetchAllFavoriteMovies(){
            for movie in favoriteMovies{
                if (movie.id == movieId) {
                    isFavorite = true
                }
            }
        }
        return isFavorite
    }
    func handleFavoriteButtonAction(movieVM:MovieItemVM)-> (() -> Void){
        return {
            if  (movieVM.isFavorite == false){
                self.persistentService?.deleteMovieWithId((movieVM.movieId)!)
            }else{
                self.persistentService?.saveFavoriteMovie(id: Int64(movieVM.movieId!), movieTitle: movieVM.movieTitle, moviePoster: movieVM.moviePoster, movieReleaseDate: movieVM.movieReleaseDate, isFavorite: movieVM.isFavorite , moviePosterPath: movieVM.moviePosterPath)
            }
        }
    }
    func cellIdentifier() -> String {
        return MovieCollectionCell.cellIdentifier()
    }
    func getGridSize(_ bounds:CGRect) -> CGSize {
        let margin = CGFloat(Constant.padding) * 3
        let width = (bounds.width - margin) / 2
        let height = ((width*3)/2) + CGFloat(Constant.bottomSpaceForMovieCollectionCell)
        return CGSize.init(width: width, height: height)
    }
    func getEdgeInsets() -> UIEdgeInsets {
        return UIEdgeInsets.init(top: CGFloat(Constant.padding), left: CGFloat(Constant.padding), bottom: CGFloat(Constant.padding), right: CGFloat(Constant.padding))
    }
    
    func getMinimumLineSpace() -> CGFloat {
        return CGFloat(Constant.padding)
    }
}

class MovieItemVM: ItemViewModel
{
    let movieId : Int?
    let movieTitle : String?
    let moviePoster : String?
    let movieReleaseDate : String?
    var isFavorite : Bool
    var favoriteButtonAction: (() -> Void)? = nil
    var moviePosterPath : String?{
        return Constant.imageBaseUrl + (self.moviePoster ?? "")
    }
    init(movieId:Int?,movieTitle: String?, moviePoster: String?, movieReleaseDate:String?, isFavorite:Bool) {
        self.movieId = movieId
        self.movieTitle = movieTitle
        self.moviePoster = moviePoster
        self.movieReleaseDate = movieReleaseDate
        self.isFavorite = isFavorite
    }
}

