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
        indicator.style = .gray
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        DispatchQueue.main.async {
        self.present(self.loadingView, animated: true, completion: nil)
        }
    }
    
    func stopLoading(completion: AlertViewAction? = nil){
        DispatchQueue.main.async {
            self.loadingView.dismiss(animated: true, completion: completion)
        }
    }
}
extension UIViewController {
   public typealias AlertViewAction = (() -> Void)

   public func presentAlertView(withTitle title: String, message: String, cancelActionTitle: String?, preferredStyle: UIAlertController.Style = .alert, confirmActionTitle: String, cancelAction: AlertViewAction?, confirmAction: AlertViewAction?) {
        
        let alertView = UIAlertController.init(title: title, message: message, preferredStyle: preferredStyle)
        
        
        
        let confirmAlertAction = UIAlertAction(
            
        title: confirmActionTitle, style: UIAlertAction.Style.default) { _ in
            
            confirmAction?()
        }
        
        
        if let cancel = cancelActionTitle, cancel != "" {
            
            let cancelAlertAction = UIAlertAction(
                
                title: cancel,
                style: UIAlertAction.Style.destructive) { _ in
                    
                    cancelAction?()
                    
                    alertView.dismiss(animated: true, completion: nil)
            }
            
            alertView.addAction(cancelAlertAction)

        }
        alertView.addAction(confirmAlertAction)

        self.present(alertView, animated: true, completion: nil)
    }
}
