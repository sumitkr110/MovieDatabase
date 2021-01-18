//
//  HomeAPIServiceProtocol.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 18/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import Foundation
protocol NowPlayingAPIServiceProtocol {
    func getNowPlayingList(completionHandler : @escaping(Result<NowPlayingDataModel,APIServiceError>)-> Void)
}

