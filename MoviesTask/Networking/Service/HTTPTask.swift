//
//  HTTPTask.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/22/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation
public typealias HTTPHeaders = [String:String]

public enum HTTPTask {    
    case requestParameters(urlParameters: Parameters?)
  
    case download(url: String)
}
