//
//  ViewController.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 18/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController {
    let apiService = APIService()
    @IBOutlet weak var nowPlayingMoviesCollectionView: UICollectionView!
    lazy var viewModel : NowPlayingViewModel = {
        let viewModel = NowPlayingViewModel.init(with: apiService)
        return viewModel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.fetchNowPlayingMovieList()
        configureCollectionView()
        bindData()
    }
    private func configureCollectionView() {
        nowPlayingMoviesCollectionView.dataSource = self
        nowPlayingMoviesCollectionView.delegate = self
        nowPlayingMoviesCollectionView.register(UINib.init(nibName:MovieCollectionCell.cellIdentifier() , bundle: nil), forCellWithReuseIdentifier: MovieCollectionCell.cellIdentifier())
       }
    //Data binding with View Model
    private func bindData(){
        viewModel.nowPlayingMovieList.addObserver(fireNow: false) { [weak self] nowPlayingMovieList in
            DispatchQueue.main.async {
                self?.nowPlayingMoviesCollectionView.reloadData()
            }
        }
        viewModel.isLoading.addObserver {[weak self] isLoading in
            DispatchQueue.main.async {
                if (isLoading){
                    self?.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.3))
                }
                else{
                    self?.view.activityStopAnimating()
                }
            }
        }
    }
}

extension NowPlayingViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.nowPlayingMovieList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifier(), for: indexPath)
        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: viewModel.nowPlayingMovieList.value[indexPath.row])
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




