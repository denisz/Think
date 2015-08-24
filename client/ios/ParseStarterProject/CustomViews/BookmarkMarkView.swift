//
//  BookmarkMarkView.swift
//  Think
//
//  Created by denis zaytcev on 8/21/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit


class BookmarkMarkView: BaseUIView {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var wrapper: UIView!
    
    override var nibName: String? {
        return "BookmarkMarkView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.font = UIFont.ioniconOfSize(40)
        self.label.text = String.ioniconWithName(.IosBookmarksOutline)
        self.wrapper.cornerEdge()
    }
    
    func animateShow() {
        self.wrapper.transform = CGAffineTransformMakeScale(0.1, 0.1)
        self.wrapper.alpha = 0
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.wrapper.transform = CGAffineTransformMakeScale(1, 1)
            self.wrapper.alpha = 1
        }) { (_) -> Void in
            self.animateHideAndDie()
        }
    }
    
    func animateHideAndDie() {
        self.wrapper.transform = CGAffineTransformMakeScale(1, 1)
        self.wrapper.alpha = 1
        
        UIView.animateWithDuration(0.2, delay: 1, options: .CurveEaseInOut, animations: { () -> Void in
            self.wrapper.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self.wrapper.alpha = 0
        }) { (_) -> Void in
            self.removeFromSuperview()
        }
        
    }

    class func showInCenterView(view: UIView){
        let bookmarkView = BookmarkMarkView()
        view.addSubview(bookmarkView)
        BaseUIView.constraintToCenter(bookmarkView, size: CGSizeMake(80, 80))
        bookmarkView.animateShow()
    }
    
    class func showInCenterViewAndAnimate(view: UIView){
        let bookmarkView = BookmarkMarkView()
        view.addSubview(bookmarkView)
        BaseUIView.constraintToCenter(bookmarkView, size: CGSizeMake(100, 100))
        bookmarkView.animateShow()
    }
}