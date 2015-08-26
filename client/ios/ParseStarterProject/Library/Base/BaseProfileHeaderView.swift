//
//  BaseProfileHeaderView.swift
//  Think
//
//  Created by denis zaytcev on 8/13/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

class BaseProfileHeaderView: BaseUIView {
    var object: PFObject?
    
    func objectDidLoad(object: PFObject) {
        self.object = object
    }
    
    func objectDidUpdate(object: PFObject) {
        self.objectDidLoad(object)
    }
}