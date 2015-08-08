//
//  UImageVIewCircle.swift
//  Think
//
//  Created by denis zaytcev on 8/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

class UIImageCircle: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cornerEdge()
    }
}