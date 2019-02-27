//
//  UIImageView+Extensions.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/24/19.
//  Copyright © 2019 SideProject. All rights reserved.
//
import Foundation
import UIKit
//protocol ImageDownloadable {
//    var task: [String: URLSessionTask] {get set}
//    func imageFromServerURL(urlString: String)
//}
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    struct TaskHolder {
        static  var task = [String: URLSessionTask]()
    }
    
    var task: [String: URLSessionTask] {
        get {
            return TaskHolder.task
        }
        set {
            TaskHolder.task = newValue
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
            weak var task = WebMovieRepository().downloadImage(imageUrl: urlString) { (data, error) in
                DispatchQueue.main.async{ [weak self] in
                    
                    if error == "cancelled" {
                        return
                    }
                    if error != nil {
                        self?.image = UIImage(named: "placeholder")
                        return
                    }
                    let image = UIImage(data: data!)
                    
                    self?.image = image
                    imageCache.setObject(image!, forKey: urlString as NSString)
                }
            }
            self.task[urlString] = task
        }
    }
    
    public func cancelTask(for urlString: String){
      
        self.task[urlString]?.cancel()
        self.task.removeValue(forKey: urlString)
    }
}
