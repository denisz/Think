//
//  UIImage+corderEdge.swift
//  Think
//
//  Created by denis zaytcev on 8/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func cornerEdge() {
        self.layer.cornerRadius = CGRectGetHeight(self.frame) * 0.5
        self.layer.masksToBounds = true
    }
}