//
//  StubGenerator.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/28/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation

class StubGenerator {
    func stubMovie() -> MovieResponse {
        let bundle = Bundle(for: type(of: self))
        
        let url = bundle.url(forResource: "Movies", withExtension: "json")!
        
        do {
            let json = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let movieRes = try! decoder.decode(MovieResponse.self, from: json)
            return movieRes
        }
        catch {
            fatalError("error decoding")
            
        }
    }
}
