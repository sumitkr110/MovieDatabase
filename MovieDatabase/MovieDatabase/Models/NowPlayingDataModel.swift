//
//  NowPlayingDataModel.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 18/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import Foundation

struct NowPlayingDataModel:Codable {
    let page : Int
    let results : [Movies]?
    let totalPages : Int?
    let totalResults : Int?
    let dates : Dates?
    enum CodingKeys: String, CodingKey {
    case page
    case results
    case totalPages = "total_pages"
    case totalResults = "total_results"
    case dates
    }
}

struct Movies:Codable {
    let posterPath : String?
    let adult : Bool?
    let overview : String?
    let releaseDate : String?
    let genreIds : [Int]?
    let id : Int?
    let originalTitle : String?
    let originalLanguage : String?
    let title : String?
    let backdropPath : String?
    let popularity : Double?
    let voteCount : Int?
    let video : Bool?
    let voteAverage : Double?
    
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult
        case overview
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
}

struct Dates : Codable{
    let maximum : String?
    let minimum : String?
}
