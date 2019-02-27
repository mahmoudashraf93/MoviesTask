//
//  WebMovieRepository.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/22/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation

class WebMovieRepository<ResponseType: MovieResponse>: WebRepository {
    
    var router: Router<MovieApi>
    var movieParser: Parser<MovieResponse>
    init(router: Router<MovieApi> = Router<MovieApi>(), movieParser: Parser<MovieResponse> = Parser<MovieResponse>()) {
        self.router = router
        self.movieParser = movieParser
    }
    
    func get(page: Int, completion: @escaping (MovieResponse?, String?) -> ()) {
        
        self.router.request(.discover(page: page), completion: { (data, response, error) in
            
            let error = ResponseHandler.validateResponse(response, data: data, error: error)
            if let responseError = error {
                completion(nil, responseError)
            }
            else {
                // decode data or handleJSON
                do {
                    let moviewResponse = try self.movieParser.parse(from: data!)
                    completion(moviewResponse, nil)
                }
                catch {
                    completion(nil, NetworkResponse.unableToDecode.rawValue)
                }
            }
        })
    }
    
    func downloadImage(imageUrl: String, completion: @escaping (Data?, String?) -> ())-> URLSessionTask? {
        
       let task = self.router.request(.downloadImage(url: imageUrl), completion: { (data, response, error) in
            
            if let responseError = error {
                completion(nil, responseError.localizedDescription)
            }
            else {
                    completion(data, nil)
            }
        })
        return task
    }
    

}
