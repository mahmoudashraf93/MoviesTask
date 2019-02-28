//
//  MovieEndPoint.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/22/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case production
}

public enum MovieApi {
    case discover(page: Int)
    case downloadImage(url: String)

}

extension MovieApi: EndPointType {
    
    var environmentBaseURL : String {
        switch self {
        case .downloadImage:
            return "https://image.tmdb.org/t/p/w185"
        default:
            switch NetworkManager.environment {
            case .production: return "https://api.themoviedb.org/3/"
        }
        
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .discover:
            return "discover/movie"
        case .downloadImage(let urlStr):
            return urlStr
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .discover(let page):
            return .requestParameters(urlParameters: ["page":page,
                                                      "api_key":NetworkManager.movieAPIKey])
        case .downloadImage(let urlStr):
            return .download(url: urlStr)

        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
