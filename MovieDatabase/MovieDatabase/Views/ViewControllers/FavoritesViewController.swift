//
//  FavoritesViewController.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 18/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var noFavoriteMoviesLabel: UILabel!
    lazy var viewModel : FavoriteViewModel = FavoriteViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavoriteMovieList()
        bindData()
    }
    private func configureCollectionView() {
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.delegate = self
        favoriteCollectionView.register(UINib.init(nibName:MovieCollectionCell.cellIdentifier() , bundle: nil), forCellWithReuseIdentifier: MovieCollectionCell.cellIdentifier())
       }
    //Data binding with View Model
    private func bindData(){
        viewModel.favoriteMovieList.addObserver(fireNow: true) { [weak self] favoriteMovies in
            DispatchQueue.main.async {
                if(favoriteMovies.count==0){
                    self?.noFavoriteMoviesLabel.isHidden = false
                }else{
                    self?.noFavoriteMoviesLabel.isHidden = true
                }
                self?.favoriteCollectionView.reloadData()
            }
        }
    }
}

extension FavoritesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoriteMovieList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifier(), for: indexPath)
        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: viewModel.favoriteMovieList.value[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.getGridSize(collectionView.bounds)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return viewModel.getMinimumLineSpace()
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return viewModel.getEdgeInsets()
       }
}

