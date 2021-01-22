//
//  HomeAPIServiceProtocol.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 18/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import Foundation
protocol MovieAPIServiceProtocol {
    func getNowPlayingList(completionHandler : @escaping(Result<MovieDataModel,APIServiceError>)-> Void)
}

protocol MoviePersistentServiceProtocol {
    @discardableResult
    func saveFavoriteMovie(id: Int64?,movieTitle: String?, moviePoster: String?, movieReleaseDate: String?,isFavorite: Bool, moviePosterPath: String?) -> MovieItem
    func fetchAllFavoriteMovies() -> [MovieItem]?
    func deleteMovieWithId(_ id:Int)
}
