//
//  InputBarView.swift
//  Think
//
//  Created by denis zaytcev on 8/24/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit


protocol InputBarViewDelegate {
    func inputBar(view: InputBarView, didTapLeftButton      button: UIButton)
    func inputBar(view: InputBarView, didTapRightButton     button: UIButton)
    func inputBar(view: InputBarView, shouldReturn          textField: UITextField)
}

class InputBarView: BaseUIView {
    @IBOutlet weak var textField:       UITextField!
    @IBOutlet weak var leftButton:      UIButton!
    @IBOutlet weak var rightButton:     UIButton!
    @IBOutlet weak var leftButtonLC:    NSLayoutConstraint!
    @IBOutlet weak var rightButtonRC:   NSLayoutConstraint!
    
    var delegate: InputBarViewDelegate?
    
    var text: String {
        get {
            return self.textField.text
        }
        set(newText) {
            self.textField.text = newText
        }
    }
    
    override var nibName: String? {
        return "InputBarView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.delegate  = self
        self.textField.tintColor = kColorNavigationBar
    }
    
    func hideLeftButton() {
        self.leftButtonLC.constant = -48
        self.leftButton.alpha = 1
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.leftButton.alpha = 0
            self.layoutIfNeeded()
        })
    }
    
    func showLeftButton() {
        self.leftButtonLC.constant = 8
        self.leftButton.alpha = 0
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.leftButton.alpha = 1
            self.layoutIfNeeded()
        })
    }
    
    @IBAction func didTapLeftButton() {
        self.delegate?.inputBar(self, didTapLeftButton: self.leftButton)
    }

    @IBAction func didTapRightButton() {
        self.delegate?.inputBar(self, didTapRightButton: self.rightButton)
    }
}

extension InputBarView: UITextFieldDelegate {
    @IBAction func textFieldChanged(sender: AnyObject!) {
        if textField.text.isEmpty {
            self.hideLeftButton()
        } else {
            self.showLeftButton()
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.inputBar(self, shouldReturn: textField)
        return true
    }
}