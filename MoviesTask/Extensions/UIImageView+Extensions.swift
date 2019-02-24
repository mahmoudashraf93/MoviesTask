//
//  UIImageView+Extensions.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/24/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async{
                self.image = cachedImage
            }
        }
        else {
            WebMovieRepository().downloadImage(imageUrl: urlString) { (data, error) in
                DispatchQueue.main.async{
                    
                    if error != nil && data == nil {
                        self.image = UIImage(named: "placeholder")
                        return
                    }
                    if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    }
                }
            }
            
        }
    }
}
