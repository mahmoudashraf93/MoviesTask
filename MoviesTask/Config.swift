//
//  Config.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/28/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation

var isUITesting: Bool {
    return ProcessInfo.processInfo.arguments.contains("UI-TESTING")
}

struct Constants{
    struct PlaceHolders {
        static let imagePlaceHolderName = "placeholder"
    }
}
