//
//  MovieCollectionCell.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 18/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import UIKit
import SDWebImage
class MovieCollectionCell: UICollectionViewCell {
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    //    var nowPlayingViewModel : MovieItemVM?
    var vm : ItemViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        self.posterImageView.image = nil
        super.prepareForReuse()
    }
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        updateFavoriteButton(sender)
    }
    func updateFavoriteButton(_ sender: UIButton)  {
        if let movieVM = (vm as? MovieItemVM){
            movieVM.isFavorite = sender.isSelected
            if  (movieVM.isFavorite == false){
                CoreDataManager.sharedManager.deleteMovieWithId((movieVM.movieId)!)
            }else{
                CoreDataManager.sharedManager.saveFavoriteMovie(id: Int64(movieVM.movieId ?? 0), movieTitle: movieVM.movieTitle, moviePoster: movieVM.moviePoster, movieReleaseDate: movieVM.movieReleaseDate, isFavorite: movieVM.isFavorite , moviePosterPath: movieVM.moviePosterPath)
            }
        }
//        else if let favVM = (vm as? MovieItem){
//            favVM.isFavorite = sender.isSelected
//            if  (favVM.isFavorite == false){
//                CoreDataManager.sharedManager.deleteMovieWithId(Int(favVM.id))
//            }
//        }
    }
}

extension MovieCollectionCell : CellConfigurable
{
    func setup(viewModel: ItemViewModel){
        if let movieVM = (viewModel as? MovieItemVM) {
            self.vm = movieVM
            if let moviePosterPath = movieVM.moviePosterPath{
                if let image = URL.init(string:moviePosterPath){
                    self.posterImageView.sd_setImage(with: image, placeholderImage: nil)
                }
            }
            self.titleLabel.text = movieVM.movieTitle
            self.releaseDateLabel.text = movieVM.movieReleaseDate
            self.favoriteButton.isSelected = movieVM.isFavorite
        }
        else if let favoriteViewModel = (viewModel as? MovieItem) {
            self.vm = favoriteViewModel
            if let moviePosterPath = favoriteViewModel.moviePosterPath{
                if let image = URL.init(string:moviePosterPath){
                    self.posterImageView.sd_setImage(with: image, placeholderImage: nil)
                }
            }
            self.titleLabel.text = favoriteViewModel.movieTitle
            self.releaseDateLabel.text = favoriteViewModel.movieReleaseDate
            self.favoriteButton.isHidden = true
        }
    }
    
}
