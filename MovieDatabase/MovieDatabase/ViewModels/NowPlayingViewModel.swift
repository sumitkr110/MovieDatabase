//
//  HomeViewModel.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 18/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import Foundation
import UIKit

class NowPlayingViewModel {
    var nowPlayingMovieList =  Observable<[MovieItemVM]>(value: [])
    var isLoading = Observable<Bool> (value: true)
    var apiService : NowPlayingAPIServiceProtocol?
    
    init(with apiService:NowPlayingAPIServiceProtocol?) {
        self.apiService = apiService
    }
    func fetchNowPlayingMovieList(){
        self.apiService?.getNowPlayingList{[weak self] result in
            switch result{
            case .success(let nowPlayingDataModel):
                self?.buildItemViewModelFrom(nowPlayingVM: nowPlayingDataModel)
                self?.isLoading.value = false
            case .failure(let error):
                self?.isLoading.value = false
                print(error)
            }
        }
    }
    private func buildItemViewModelFrom(nowPlayingVM:NowPlayingDataModel) {
        if let movies = nowPlayingVM.results{
            for movie in movies {
                let movieItemVM = MovieItemVM.init(movieId: movie.id, movieTitle: movie.title, moviePoster: movie.posterPath, movieReleaseDate: movie.releaseDate, isFavorite: checkForFavoriteMovies(movie.id!))
                nowPlayingMovieList.value.append(movieItemVM)
            }
        }
    }
    private func checkForFavoriteMovies(_ movieId: Int) -> Bool{
        var isFavorite = false
        if let favoriteMovies = CoreDataManager.sharedManager.fetchAllFavoriteMovies(){
            for movie in favoriteMovies{
                if (movie.id == movieId) {
                    isFavorite = true
                }
            }
        }
        return isFavorite
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

