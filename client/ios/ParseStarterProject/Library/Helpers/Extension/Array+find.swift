//
//  Array+find.swift
//  Think
//
//  Created by denis zaytcev on 8/18/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation

extension Array {
    func find(includedElement: Element -> Bool) -> Int? {
        for (idx, element) in self.enumerate() {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
    
    mutating func remove(includedElement: Element -> Bool) -> Bool {
        
        for (idx, element) in self.enumerate() {
            if includedElement(element) {
                self.removeAtIndex(idx)
                return true
            }
        }
        return false
    }
}