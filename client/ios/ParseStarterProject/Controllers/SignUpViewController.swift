//
//  SignUpController.swift
//  Think
//
//  Created by denis zaytcev on 8/6/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

protocol SignUpViewControllerDelegate {
    func signUp(controller: SignUpViewController, successful user: PFUser)
    func signUp(controller: SignUpViewController, failed error: NSError)
}

@objc(SignUpViewController) class SignUpViewController: UIViewController {
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var fadeActivity: UIView!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var betweenSigninAndNicknameConstraint: NSLayoutConstraint!
    @IBOutlet weak var betweenSigninAndEmailConstraint: NSLayoutConstraint!
    @IBOutlet weak var betweenEmailAndPasswordConstraint: NSLayoutConstraint!
    
    var delegate: SignUpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UIColor(red:0.47, green:0.87, blue:1, alpha:1)
        
        self.emailAddress.changeColorPlaceholder(UIColor.whiteColor())
        self.password.changeColorPlaceholder(UIColor.whiteColor())
        self.nickname.changeColorPlaceholder(UIColor.whiteColor())
        
        self.emailAddress.borderBottom(color)
        self.password.borderBottom(color)
        self.nickname.borderBottom(color)
        
        self.signUp.cornerEdge()
        
        self.setupKeyboard()
    }

    deinit {
        self.unsetupKeyboard()
    }

    override func updateConstraintKeyboard(hide: Bool) {
        if hide {
            self.topConstraint.constant = 60
            self.betweenSigninAndNicknameConstraint.constant = 60
            self.betweenSigninAndEmailConstraint.constant = 20
            self.betweenEmailAndPasswordConstraint.constant = 20
        } else {
            self.topConstraint.constant = 15
            self.betweenSigninAndNicknameConstraint.constant = 10
            self.betweenSigninAndEmailConstraint.constant = 10
            self.betweenEmailAndPasswordConstraint.constant = 10
        }
    }
    
    override func keyboardWillShowNotification(notification: NSNotification) {
        super.keyboardWillShowNotification(notification)
        self.message!.text = ""
    }

    @IBAction func didTapLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapSignUp(sender: AnyObject) {
        self.processSignUp()
    }
    
    func processSignUp() {
        // Start activity indicator
        self.fadeActivity.hidden = false
        self.hideKeyboard()

        var userEmailAddress = emailAddress.text
        let userPassword = password.text
        let userName = nickname.text
        
        // Ensure username is lowercase
        userEmailAddress = userEmailAddress.lowercaseString
        
        // Add email address validation
        
        // Create the user
        var user = PFUser()
        user.username = userName
        user.password = userPassword
        user.email = userEmailAddress
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            
            self.fadeActivity.hidden = true
            
            if error == nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.signUp(self, successful: user)
                }
                
            } else {
                if let message: AnyObject = error!.userInfo!["error"] {
                    self.message.text = "\(message)"
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.signUp(self, failed: error!)
                }
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.LightContent
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.processSignUp()
        return true
    }
}