//
//  Array+find.swift
//  Think
//
//  Created by denis zaytcev on 8/18/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation

extension Array {
    func find(includedElement: T -> Bool) -> Int? {
        for (idx, element) in enumerate(self) {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
    
    mutating func remove(includedElement: T -> Bool) -> Bool {
        
        for (idx, element) in enumerate(self) {
            if includedElement(element) {
                self.removeAtIndex(idx)
                return true
            }
        }
        return false
    }
}