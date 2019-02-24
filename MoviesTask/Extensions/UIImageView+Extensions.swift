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
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            print(Thread.current)
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}
