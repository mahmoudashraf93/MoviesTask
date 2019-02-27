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
        //create an alert controller
        
        
        //create an activity indicator
        let indicator = UIActivityIndicatorView(frame: loadingView.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //add the activity indicator as a subview of the alert controller's view
        loadingView.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
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
