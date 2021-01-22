//
//  MockHomeAPIServiceClient.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 22/01/21.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import XCTest
@testable import MovieDatabase

class MockAPIServiceClient{
    var shouldReturnError = false
    var getMovieListWascalled = false
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .useDefaultKeys
        return jsonDecoder
    }()
    func reset(){
        shouldReturnError = false
        getMovieListWascalled = false
    }
    convenience init(){
        self.init(false)
    }
    init(_ shouldReturnError:Bool) {
        self.shouldReturnError = shouldReturnError
    }
    var mockBookListData : Data?{
        getDataFromJson()
    }
    
}
extension MockAPIServiceClient : MovieAPIServiceProtocol{
    func getNowPlayingList(completionHandler : @escaping(Result<MovieDataModel,APIServiceError>)-> Void) {
        getMovieListWascalled = true
        if shouldReturnError{
            completionHandler(.failure(.apiError))
        }else{
            if let data = mockBookListData{
                do{
                    let value = try self.jsonDecoder.decode(MovieDataModel.self, from: data)
                    completionHandler(.success(value))
                }catch{
                    completionHandler(.failure(.decodeError))
                }
            }else{
                completionHandler(.failure(.noData))
            }
        }
    }
    func getDataFromJson() -> Data? {
        guard let path = Bundle(for: type(of: self)).path(forResource: "MovieData", ofType: "json") else { return nil}
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }
}
