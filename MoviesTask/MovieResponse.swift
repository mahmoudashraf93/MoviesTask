//
//  MovieResponse.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/22/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation

class MovieResponse: Codable {
    let page, totalResults, totalPages: Int?
    let movies: [Movie]?

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        page = try container.decode(Int.self, forKey: .page)
        totalResults = try container.decode(Int.self, forKey: .totalResults)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        movies = try container.decode([Movie].self, forKey: .movies)
        
    }

}

class Movie: Codable {
    var title: String?
    var posterPath: String?
    var overview, releaseDate: String?
    enum CodingKeys: String, CodingKey {
     
        case title
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
    }
    required init(from decoder: Decoder) throws {
        let movieContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        posterPath = try movieContainer.decode(String.self, forKey: .posterPath)
        title = try movieContainer.decode(String.self, forKey: .title)
        releaseDate = try movieContainer.decode(String.self, forKey: .releaseDate)
        overview = try movieContainer.decode(String.self, forKey: .overview)
    }
}

