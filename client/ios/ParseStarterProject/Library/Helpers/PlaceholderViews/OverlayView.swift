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
}