//
//  UIImageView+Extensions.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/24/19.
//  Copyright © 2019 SideProject. All rights reserved.
//
import Foundation
import UIKit
protocol ImageDownloadable {
    var task: URLSessionTask? {get set}
    func imageFromServerURL(urlString: String)
}
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView: ImageDownloadable {
    struct Holder {
        static var task: URLSessionTask?
    }
    
    var task: URLSessionTask? {
        get {
            return Holder.task
        }
        set {
            Holder.task = newValue
        }
    }
    
    public func imageFromServerURL(urlString: String) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async{
                self.image = cachedImage
            }
        }
        else {
            self.task = WebMovieRepository().downloadImage(imageUrl: urlString) { (data, error) in
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    if error == "cancelled" {
                        return
                    }
                    if error != nil {
                        self.image = UIImage(named: "placeholder")
                        return
                    }
                    let image = UIImage(data: data!)
                    self.image = image
                    imageCache.setObject(image!, forKey: urlString as NSString)
                })
            }
        }
    }
    
    public func cancelTask(){
        self.task?.cancel()
    }
}
