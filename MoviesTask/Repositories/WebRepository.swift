//
//  WebRepository.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/22/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation


protocol WebRepository: class {
    func get(page: Int, completion: @escaping (_ response: MovieResponse?,_ error: String?)->())

}

