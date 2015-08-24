//
//  OverlayView.swift
//  Think
//
//  Created by denis zaytcev on 8/20/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit


class OverlayView: BaseUIView {
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override var nibName: String? {
        return "OverlayView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class func createInView(view: UIView) -> OverlayView {
        let overlay = OverlayView()
        view.addSubview(overlay)
        BaseUIView.constraintToFit(overlay)
        overlay.alpha = 0
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            overlay.alpha = 1
        })
        
        return overlay
    }
}