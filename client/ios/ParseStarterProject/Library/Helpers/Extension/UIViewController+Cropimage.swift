//
//  UIViewController+Cropimage.swift
//  Think
//
//  Created by denis zaytcev on 8/25/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import TOCropViewController


extension UIViewController: TOCropViewControllerDelegate  {
    
    func cropViewController(image: UIImage) {
        
    }
    
    public func cropViewController(cropViewController: TOCropViewController!, didCropToImage image: UIImage!, withRect cropRect: CGRect, angle: Int) {
        self.cropViewController(image)
        cropViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cropImageWithCropViewController(image: UIImage) {
        var cropController: TOCropViewController = TOCropViewController(image: image)
        cropController.delegate = self
        self.presentViewController(cropController, animated: true, completion: nil)
    }
    
    public func cropViewController(cropViewController: TOCropViewController!, didFinishCancelled cancelled: Bool) {
        cropViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

