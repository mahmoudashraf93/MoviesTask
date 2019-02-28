//
//  MoviesViewModel.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/26/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation

class MoviesViewModel {
    
    private var webMovies: [WebMoviesListViewModel] = [WebMoviesListViewModel]() {
        didSet{
            // reload tableView
            self.reloadTableviewClosure?()
        }
    }
    private var userAddedMovies: [UserAddedMoviesListViewModel] = [UserAddedMoviesListViewModel]() {
        didSet{
            // reload tableview
            self.reloadTableviewClosure?()

        }
    }
    var reloadTableviewClosure: (()->())?
    var failureClosure: ((String?)->())?
    
    var error: String? {
        didSet {
            self.failureClosure?(error)
        }
    }
   
    let webMoviesRepo: WebMovieRepository
    private var pageNumber = 1
    private var totalPages = 1
   
    var isPaging: Bool {
        return pageNumber < self.totalPages
    }
    var numberOfRowsForMovies: Int {
        return isPaging ? self.webMovies.count + 1 : self.webMovies.count
    }
    var numberOfRowsForUserAddedMovies: Int {
        return self.userAddedMovies.count
    }
    init(webMoviesRepo: WebMovieRepository = WebMovieRepository()) {
        self.webMoviesRepo = webMoviesRepo
    }
    
   public func getMovies(for page: Int = 1){
        self.webMoviesRepo.get(page: self.pageNumber) {[unowned self](movieResponse, error) in
            
            guard error == nil else {
                self.error = error
                return
            }
            self.totalPages = movieResponse?.totalPages ?? 0
            
            guard let movies = movieResponse?.movies else {
                return
            }
           
            self.mapFetchedMovies(movies: movies)
            self.pageNumber += 1
            
        }
    }
    public func getWebMovieCellViewModel(at index: Int) -> WebMoviesListViewModel {
       return self.webMovies[index]
    }
    public func getUserAddedMovieCellViewModel(at index: Int) -> UserAddedMoviesListViewModel {
        return self.userAddedMovies[index]
    }
    public func shouldShowLoadingRow(indexPath: IndexPath) -> Bool {
       return indexPath.row == self.webMovies.count && self.isPaging && !self.isCellForMyMoviesSection(indexPath:indexPath)
    }
    public func isCellForMyMoviesSection (indexPath: IndexPath) -> Bool {
        return self.numberOfRowsForUserAddedMovies > 0 && indexPath.section == 0
    }
    private func mapFetchedMovies(movies: [Movie]){
        
        let mappedMovies = movies.map {
            WebMoviesListViewModel(titleText: $0.title ?? "",
                                   releaseDateText: $0.releaseDate ?? "",
                                   overviewText: $0.overview ?? "",
                                   imagePath: $0.posterPath ?? "")
        }
        self.webMovies.append(contentsOf: mappedMovies)
    
    }
}

extension MoviesViewModel: AddMovieVCDelegate {
    func didAdd(_ movie: UserAddedMoviesListViewModel) {
        
       self.userAddedMovies.append(movie)
    }
    
    
}


struct WebMoviesListViewModel {
    let titleText: String
    let releaseDateText: String
    let overviewText: String
    let imagePath: String?
}
struct UserAddedMoviesListViewModel {
    let titleText: String
    let releaseDateText: String?
    let overviewText: String?
    let imageData: Data?
}
