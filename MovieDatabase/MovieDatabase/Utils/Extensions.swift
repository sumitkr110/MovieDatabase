//
//  Extensions.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 18/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = Constant.activityBackgroundViewTag
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        backgroundView.addSubview(activityIndicator)
        self.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = viewWithTag(Constant.activityBackgroundViewTag){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}

extension UICollectionViewCell {
    /// Generated cell identifier derived from class name
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
