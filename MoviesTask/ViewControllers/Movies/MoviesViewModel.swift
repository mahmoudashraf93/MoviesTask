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
    var userAdderMovies : DynamicValue<[Movie]?> = DynamicValue<[Movie]?>(nil)
    let webMoviesRepo: WebMovieRepository<MovieResponse>
    private var pageNumber = 1
    private var totalPages = 1
     var isPaging: Bool {
        return pageNumber < self.totalPages
    }
     var numberOfRowsForMovies: Int {
        return isPaging ? (self.movies.value?.count ?? 0) + 1 : self.movies.value?.count ?? 0
    }
     var numberOfRowsForUserAddedMovies: Int {
        return self.userAdderMovies.value?.count ?? -1
    }
    init(webMoviesRepo: WebMovieRepository<MovieResponse> = WebMovieRepository(), movies: DynamicValue<[Movie]?> = DynamicValue<[Movie]?>(nil), userAddedMoves: DynamicValue<[Movie]?> = DynamicValue<[Movie]?>(nil)  ) {
        self.webMoviesRepo = webMoviesRepo
        self.movies = movies
        self.userAdderMovies = userAddedMoves
    }
    
    func getMovies(for page: Int = 1){
        self.webMoviesRepo.get(page: self.pageNumber) {[unowned self](movieResponse, error) in
            
            guard error == nil else {
                return
            }
            self.totalPages = movieResponse?.totalPages ?? 0
            guard let movies = movieResponse?.movies else {
                return
            }
//            let movie = Movie(title: "test", overview: "hahahahahahahah", releaseDate: "28-9-1993", imagePoster: nil)
//            self.userAdderMovies.value = [movie]
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

extension MoviesViewModel: AddMovieVCDelegate {
    func didAdd(_ movie: Movie) {
        if self.userAdderMovies.value == nil {
            self.userAdderMovies.value = [movie]
            return
        }
        else {
            self.userAdderMovies.value?.append(movie)
            return
        }
    }
    
    
}
