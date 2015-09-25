//
//  LoginViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/6/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

protocol LogInViewControllerDelegate {
    func logIn(controller: LogInViewController, successful user: PFUser)
    func logIn(controller: LogInViewController, facebook user: PFUser)
    func logIn(controller: LogInViewController, failed error: NSError)
    func logIn(controller: LogInViewController, skiped button: UIView)
    func logIn(controller: LogInViewController, forgot button: UIView, email: String?)
    func logIn(controller: LogInViewController, sign signController: UIViewController)
}

// (kConstantTop, kConstantSN, show (kConstantTop, kConstantSN) )
func determineContraints() -> (CGFloat, CGFloat, CGFloat, CGFloat){
    if UIDevice().userInterfaceIdiom == .Phone {
        print(UIScreen.mainScreen().bounds.height)
        switch UIScreen.mainScreen().bounds.height {
        case 960:
            return (20, 40, -45, 25)
        case 480:
            return (20, 40, -45, 25)
        default:
            return (60, 60, 15, 35)
        }
    }
    return (60, 60, 15, 35)
}

@objc(LogInViewController) class LogInViewController: UIViewController {
    @IBOutlet weak var fadeActivity: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var forggetPassword: UIButton!
    @IBOutlet weak var skip: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var betweenSigninAndNicknameConstraint: NSLayoutConstraint!
    
    var signUpController: UIViewController?
    var delegate: LogInViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor(red:0.47, green:0.87, blue:1, alpha:1)
        
        self.emailAddress.changeColorPlaceholder(UIColor.whiteColor())
        self.password.changeColorPlaceholder(UIColor.whiteColor())
        
        self.emailAddress.borderBottom(color)
        self.password.borderBottom(color)
        
        self.password.delegate = self
        
        self.facebook.cornerEdge()
        self.signUp.cornerEdge()
        
        self.prepareLayoutContraints()
    }
    
    func prepareLayoutContraints() {
        let constraints = determineContraints()
        self.topConstraint.constant = constraints.0
        self.betweenSigninAndNicknameConstraint.constant = constraints.1
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.unsetupKeyboard()
    }
    
    override func updateConstraintKeyboard(hide: Bool, minY: CGFloat, maxY: CGFloat) {
        let constraints = determineContraints()
        if hide {
            self.topConstraint.constant = constraints.0
            self.betweenSigninAndNicknameConstraint.constant = constraints.1
        } else {
            self.topConstraint.constant = constraints.2
            self.betweenSigninAndNicknameConstraint.constant = constraints.3
        }
    }
    
    override func keyboardWillShowNotification(notification: NSNotification) {
        super.keyboardWillShowNotification(notification)
        self.message!.text = ""
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupKeyboard(true)
        
        let currentUser = PFUser.currentUser()
        if currentUser!.sessionToken != nil {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        
        UIApplication.sharedApplication().setStatusBarOrientation(UIInterfaceOrientation.Portrait, animated: true)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    @IBAction func didTapForgot(sender: AnyObject) {
        var userEmailAddress = emailAddress.text
        userEmailAddress = userEmailAddress!.lowercaseString
        self.delegate?.logIn(self, forgot: self.forggetPassword, email: userEmailAddress)
    }
    
    @IBAction func didTapSignIn(sender: AnyObject) {
        if let controller = self.signUpController {
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapFacebook(sender: AnyObject) {
        let permissions = ["public_profile"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let newUser = user {
                
                newUser.setObject(UserModel.username(newUser), forKey: kUserDisplayNameKey)
                newUser.saveInBackground()
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.logIn(self, facebook: newUser)
                }
                
                if newUser.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
            } else {
                self.message.text = "Uh oh. You cancelled the Facebook login."
            }
        }
    }
    
    @IBAction func didTapSkip(sender: AnyObject) {
        self.fadeActivity.hidden = false
        self.hideKeyboard()

        PFAnonymousUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            self.fadeActivity.hidden = true
            if error != nil || user == nil {
                if let message: AnyObject = error!.userInfo["error"] {
                    self.message.text = "\(message)"
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.logIn(self, failed: error!)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.logIn(self, skiped: self.skip)
                }
            }
        }
    }
    
    @IBAction func didTapLogIn(sender: AnyObject) {
        self.processLogIn()
    }
    
    func processLogIn() {
        self.fadeActivity.hidden = false
        self.hideKeyboard()
        
        var userEmailAddress = emailAddress.text
        userEmailAddress = userEmailAddress!.lowercaseString
        let userPassword = password.text
        
        print("\(userEmailAddress) \(userPassword)")

        PFUser.logInWithUsernameInBackground(userEmailAddress!, password:userPassword!) {
            (user: PFUser?, error: NSError?) -> Void in
            self.fadeActivity.hidden = true
            
            if let newUser = user {
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.logIn(self, successful: newUser)
                }
            } else {
                
                if let message: AnyObject = error!.userInfo["error"] {
                    self.message.text = "\(message)"
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.logIn(self, failed: error!)
                }
            }
        }
    }
    
    func addCornerEdge(view: UIView) {
        view.layer.cornerRadius = CGRectGetHeight(view.frame) * 0.5
        view.layer.masksToBounds = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.LightContent
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.processLogIn()
        return true
    }
}