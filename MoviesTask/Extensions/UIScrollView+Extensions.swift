//
//  UIScrollView+Extensions.swift
//  MoviesTask
//
//  Created by mahmoud ashraf on 2/23/19.
//  Copyright © 2019 SideProject. All rights reserved.
//

import Foundation
import UIKit
extension UIScrollView {
    
    func scrollToBottom(view: UIView) {
        let bottomOffset = CGPoint(x: 0, y: (contentSize.height - bounds.size.height + contentInset.bottom) - view.frame.origin.y)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
