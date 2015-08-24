//
//  UIView+cornerEdge.swift
//  Think
//
//  Created by denis zaytcev on 8/21/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation

extension UIView {
    func cornerEdge() {
        self.layer.cornerRadius = CGRectGetHeight(self.frame) * 0.5
        self.layer.masksToBounds = true
    }
}