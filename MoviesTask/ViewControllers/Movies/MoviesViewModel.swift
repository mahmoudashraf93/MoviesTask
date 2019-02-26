//
//  MoviesViewModel.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/26/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation

class MoviesViewModel {
    
    var movies : DynamicValue<[Movie]?> = DynamicValue<[Movie]?>(nil)
    let webMoviesRepo: WebMovieRepository<MovieResponse>
    private var pageNumber = 1
    private var totalPages = 1
    var isPaging: Bool {
        return pageNumber < self.totalPages
    }
    var numberOfRowsForMovies: Int {
        return isPaging ? (self.movies.value?.count ?? 0) + 1 : self.movies.value?.count ?? 0
    }
    init(webMoviesRepo: WebMovieRepository<MovieResponse> = WebMovieRepository()) {
        self.webMoviesRepo = webMoviesRepo
    }
    
    func getMovies(for page: Int = 1){
        self.webMoviesRepo.get(page: self.pageNumber) { (movieResponse, error) in
            
            guard error == nil else {
                return
            }
            self.totalPages = movieResponse?.totalPages ?? 0
            guard let movies = movieResponse?.movies else {
                return
            }
            if self.pageNumber == 1 {
                self.movies.value = movies
            }
            else {
                self.movies.value?.append(contentsOf: movies)

            }
            self.pageNumber += 1

        }
    }
}
