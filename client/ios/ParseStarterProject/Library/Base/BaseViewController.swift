//
//  BaseViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/6/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

let kImageNamdeForBackBtn = "ic_back"
let kImageNamdeForMenuBtn = "ic_menu"

extension UIViewController {
    var imageLeftBtn: String {
        return kImageNamdeForBackBtn
    }
    
    func configureNavigationBarBackBtn(color: UIColor) {
        var image = UIImage(named: imageLeftBtn) as UIImage!
//        image = image.imageWithColor(color)
        
        var btnBack:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapLeftBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.contentEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        btnBack.setTitleColor(UIColor(red:0.2, green:0.2, blue:0.2, alpha:1), forState: UIControlState.Normal)
        btnBack.sizeToFit()
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    func didTapLeftBtn(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
}

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarBackBtn(UIColor(red:0.2, green:0.2, blue:0.2, alpha:1))
    }
}
