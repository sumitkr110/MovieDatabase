//
//  CellConfigurable.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 18/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import Foundation
import UIKit
protocol CellConfigurable {
    func setup(viewModel: ItemViewModel) // Provide a generic function for item set up
}
protocol ItemViewModel {
}

