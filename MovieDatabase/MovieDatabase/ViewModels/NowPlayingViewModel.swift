//
//  HomeViewModel.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 18/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import Foundation
struct ErrorResult  {
    let errorMessage : String
    let errorTitle : String
    
}
class NowPlayingViewModel {
    var nowPlayingMovieList =  Observable<[MovieItemVM]>(value: [])
    var isLoading = Observable<Bool> (value: true)
    var errorResult = Observable<ErrorResult?>(value: nil)
    var apiService : NowPlayingAPIServiceProtocol?
    
    init(with apiService:NowPlayingAPIServiceProtocol?) {
        self.apiService = apiService
    }
    func fetchNowPlayingMovieList(){
        self.apiService?.getNowPlayingList{[weak self] result in
            switch result{
            case .success(let nowPlayingDataModel):
                self?.buildItemViewModelFrom(nowPlayingVM: nowPlayingDataModel)
            case .failure(let error):
                print(error)
            }
        }
    }
    private func buildItemViewModelFrom(nowPlayingVM:NowPlayingDataModel) {
        if let movies = nowPlayingVM.results{
            for movie in movies {
                let movieItemVM = MovieItemVM(movieTitle: movie.title, moviePoster: movie.posterPath, moviePopularity: movie.popularity, movieReleaseDate: movie.releaseDate)
                nowPlayingMovieList.value.append(movieItemVM)
            }
        }
    }
}

struct MovieItemVM: ItemViewModel
{
    let movieTitle : String?
    let moviePoster : String?
    let moviePopularity : Double?
    let movieReleaseDate : String?
}

