//
//  URLSessionDataTaskProtocol.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/28/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation
protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
