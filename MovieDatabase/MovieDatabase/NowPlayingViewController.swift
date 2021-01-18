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
    lazy var viewModel : NowPlayingViewModel = {
        let viewModel = NowPlayingViewModel.init(with: apiService)
            return viewModel
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.fetchNowPlayingMovieList()
        bindData()
    }
    //Data binding with View Model
        private func bindData(){
            viewModel.errorResult.addObserver(fireNow: false) { [weak self] errorResult in
                DispatchQueue.main.async {
                   
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

