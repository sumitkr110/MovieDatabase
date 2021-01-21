//
//  FavoriteViewModel.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 20/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import Foundation
import UIKit
class FavoriteViewModel {
    var favoriteMovieList =  Observable<[MovieItem]>(value: [])
    
    func fetchFavoriteMovieList(){
        if let favoriteMovies = CoreDataManager.sharedManager.fetchAllFavoriteMovies(){
            
            favoriteMovieList.value = favoriteMovies
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
