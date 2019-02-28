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
    struct TaskHolder {
        static  var task = [String: URLSessionDataTaskProtocol]()
    }
    
    var taskStorage: [String: URLSessionDataTaskProtocol] {
        get {
            return TaskHolder.task
        }
        set {
            TaskHolder.task = newValue
        }
    }
    
    public func image(from urlString: String) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async{
                self.image = cachedImage
            }
        }
        else {
            let task = WebMovieRepository().downloadImage(imageUrl: urlString) { (data, error) in
                if error == "cancelled" {
                    return
                }
                DispatchQueue.main.async{ [unowned self] in
                    
                    if error != nil {
                        self.image = UIImage(named: "placeholder")
                        return
                    }
                    
                    guard let imageData = data else {
                        self.image = UIImage(named: "placeholder")
                        return
                    }
                    guard let image = UIImage(data: imageData) else {
                        self.image = UIImage(named: "placeholder")
                        return
                    }
                    UIView.transition(with: self,
                                      duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        self.image = image
                                        
                    },
                                      completion: nil)
                    imageCache.setObject(image, forKey: urlString as NSString)
                }
            }
            self.taskStorage[urlString] = task
        }
    }
    
    public func cancelTask(for urlString: String){
        
        self.taskStorage[urlString]?.cancel()
        self.taskStorage.removeValue(forKey: urlString)
    }
}
