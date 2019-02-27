//
//  UIViewController+Extensions.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/26/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation
import UIKit

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
