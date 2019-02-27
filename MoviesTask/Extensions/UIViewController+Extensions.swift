//
//  UIViewController+Extensions.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/26/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation
import UIKit

extension MoviesViewController {
    func startLoading() {
     
        let indicator = UIActivityIndicatorView(frame: loadingView.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        loadingView.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        DispatchQueue.main.async {
        self.present(self.loadingView, animated: true, completion: nil)
        }
    }
    
    func stopLoading(){
        DispatchQueue.main.async {
            self.loadingView.dismiss(animated: true, completion: nil)
        }
    }
}
