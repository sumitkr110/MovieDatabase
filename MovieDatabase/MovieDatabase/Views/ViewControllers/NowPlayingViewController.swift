//
//  NowPlayingViewController.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 18/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController {
    @IBOutlet weak var nowPlayingMoviesCollectionView: UICollectionView!
    let apiService = APIService()
    private lazy var coreDataStack = CoreDataStack()
    private lazy var persistentService = PersistentService(
        managedObjectContext: coreDataStack.mainContext,
        coreDataStack: coreDataStack)
    lazy var viewModel : MovieViewModel = {
        let viewModel = MovieViewModel.init(withAPIService: apiService, andPersistentService:persistentService)
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
                for movieVM in nowPlayingMovieList{
                    movieVM.favoriteButtonAction = self?.viewModel.handleFavoriteButtonAction(movieVM: movieVM)
                }
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
        viewModel.error.addObserver(fireNow: false) { [weak self] error in
            DispatchQueue.main.async {
                
                self?.showAlertWithErrorResult(error: error!)
            }
        }
    }
    private func showAlertWithErrorResult(error:APIServiceError) {
        let alert = UIAlertController(title: Constant.genericAlertTitle, message: Constant.genericAlertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    deinit {
        viewModel.nowPlayingMovieList.removeObserver()
        viewModel.isLoading.removeObserver()
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




