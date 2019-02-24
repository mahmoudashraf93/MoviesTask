//
//  UIImageView+Extensions.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/24/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation
import UIKit


extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        self.image = nil
        WebMovieRepository().downloadImage(imageUrl: urlString) { (data, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                
                if error != nil {
                    self.image = UIImage(named: "placeholder")
                    return
                }
                let image = UIImage(data: data!)
                self.image = image
                self.layoutSubviews()
            })
        }

    }
    
}
