//
//  UIViewController+Overlay.swift
//  Think
//
//  Created by denis zaytcev on 8/20/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func createOverlay() -> UIView {
        let overlay = OverlayView()
        self.view.addSubview(overlay)
        overlay.constraintToFit()
        overlay.alpha = 0
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            overlay.alpha = 1
        })
        
        return overlay
    }
}