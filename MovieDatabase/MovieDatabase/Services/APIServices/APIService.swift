//
//  NetworkManager.swift
//  MovieDatabase
//
//  Created by Sumit Kumar on 18/01/21.
//  Copyright © 2021 sumitkr110. All rights reserved.
//

import Foundation
enum APIServiceError : Error {
    case decodeError
    case invalidResponse
    case apiError
    case invalidEndpoint
}
class APIService{
    
    private let urlSession = URLSession.shared
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .useDefaultKeys
        return jsonDecoder
    }()
    
    enum Endpoint : String {
        case nowPlaying = "/3/movie/now_playing"
    }
    
    private func callAPIWithUrl<T:Codable>(request:URLRequest,completionHandler: @escaping (Result<T,APIServiceError>)->Void)  {
        self.urlSession.dataTask(with: request) { data,response,error in
            if error != nil
            {
                completionHandler(.failure(APIServiceError.apiError))
            }
            guard let responseStatusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= responseStatusCode else {
                completionHandler(.failure(APIServiceError.invalidResponse))
                return
            }
            do {
                let value = try self.jsonDecoder.decode(T.self, from: data!)
                completionHandler(.success(value))
            }
            catch{
                print(error)
                completionHandler(.failure(APIServiceError.decodeError))
            }
        }.resume()
    }
}

extension APIService : MovieAPIServiceProtocol{
    
    func getNowPlayingList(completionHandler : @escaping(Result<MovieDataModel,APIServiceError>)-> Void)  {
        guard let url = URL(string:Constant.baseUrl)?.appendingPathComponent(Endpoint.nowPlaying.rawValue)else {
            completionHandler(.failure(APIServiceError.invalidEndpoint))
            return
        }
        guard var urlComponents = URLComponents (url: url, resolvingAgainstBaseURL: true) else {
            completionHandler(.failure(APIServiceError.invalidEndpoint))
            return
        }
        let queryItems =  [URLQueryItem(name: Constant.apiKey, value: Constant.apiKeyValue)]
        urlComponents.queryItems = queryItems
        guard  let movieListUrl = urlComponents.url  else {
            completionHandler(.failure(APIServiceError.invalidEndpoint))
            return
        }
        var urlRequest = URLRequest.init(url: movieListUrl)
        urlRequest.httpMethod = "GET"
        // urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        self.callAPIWithUrl(request: urlRequest, completionHandler: completionHandler)
    }
}
