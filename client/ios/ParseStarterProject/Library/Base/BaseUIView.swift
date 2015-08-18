//
//  BaseUIView.swift
//  Think
//
//  Created by denis zaytcev on 8/13/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit



class BaseUIView: UIView {
    var view: UIView!
    
    var nibName: String? {
        return nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        if let view = loadViewFromNib() {
            view.frame = bounds
            view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
            addSubview(view)
            
            self.view = view
            self.userInteractionEnabled = true
            viewDidLoad()
        }
    }
    
    func loadViewFromNib() -> UIView? {
        if let nibName = self.nibName {
            let bundle = NSBundle(forClass: self.dynamicType)
            let nib = UINib(nibName: nibName, bundle: bundle)
            let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
            return view
        }
        
        return nil
    }
    
    func viewDidLoad() {}
}