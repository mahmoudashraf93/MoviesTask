//
//  Parser.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/22/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation

protocol Parcelable {
    associatedtype ModelType
    func parse(from data: Data) throws -> ModelType
}

class Parser<T: Codable>: Parcelable {
    
    private let jsonDecoder: JSONDecoder
    
    public init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
    }
    
    func parse(from data: Data) throws -> T {
        let response = try jsonDecoder.decode(T.self, from: data)
        return response
    }
}
