//
//  MovieItem+CoreDataProperties.swift
//  
//
//  Created by Sumit Kumar on 20/01/21.
//
//

import Foundation
import CoreData


extension MovieItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieItem> {
        return NSFetchRequest<MovieItem>(entityName: "MovieItem")
    }

    @NSManaged public var isFavorite: Bool
    @NSManaged public var moviePoster: String?
    @NSManaged public var moviePosterPath: String?
    @NSManaged public var movieReleaseDate: String?
    @NSManaged public var movieTitle: String?
    @NSManaged public var id: Int64

}
