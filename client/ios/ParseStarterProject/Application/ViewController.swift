//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController {
    static var started: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
    }
    
    override func viewDidAppear(animated: Bool) {
        let currentUser = PFUser.currentUser()
        
        if currentUser!.sessionToken != nil {
            self.app()
        } else {
            self.logIn()
        }
    }
    
    func logIn() {
        let logInController  = LogInViewController()
        let signUpController = SignUpViewController()
        
        logInController.delegate = self
        logInController.signUpController = signUpController
        signUpController.delegate = self
        
        self.presentViewController(logInController, animated:false, completion: nil)
    }
    
    func logout() {
        self.unRegisterDevice()
    }
    
    func app() {
        let appController = AppViewController()
        let navigationController = BaseNavigationController(rootViewController: appController)
        let sideMenuController = BaseSideMenuViewController(rootViewController: navigationController)
        
        setSideMenuController(sideMenuController)
        
        self.presentViewController(sideMenuController, animated:true, completion: nil)
    }
    
    func unRegisterDevice() {
        let install = PFInstallation.currentInstallation()
        install.removeObjectForKey(kInstallationUserKey)
        install.saveInBackground()
    }
    
    func registerDevice() {
        let user = PFUser.currentUser()
        let privateChannelName = "user_\(user!.objectId)"
        let install = PFInstallation.currentInstallation()
        install.setObject(user!, forKey: kInstallationUserKey)
        install.addUniqueObject(privateChannelName, forKey: kInstallationChannelsKey)
        install.saveEventually()
    }
    
    class func globalApperence() {
        UITextField.appearance().tintColor  = UIColor.whiteColor()
        UISwitch.appearance().tintColor     = kColorSwitchTint
        UISwitch.appearance().onTintColor   = kColorSwitchTint
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: kColorNavigationBar,
            NSFontAttributeName: kFontNavigationBarTitle
        ]
        
        UINavigationBar.appearance().backgroundColor = UIColor.whiteColor()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UIAlertViewDelegate {
    func forgot(email: String?) {
        let title = NSLocalizedString("Reset Password", comment: "Forgot password request title in PFLogInViewController")
        let message = NSLocalizedString("Please enter the email address for your account.",
            comment: "Email request message in PFLogInViewController")
        let cancel = NSLocalizedString("Cancel", comment: "Cancel")
        let ok = NSLocalizedString("OK", comment: "OK")
        
        var alertView = UIAlertView(
            title: title,
            message: message,
            delegate: self,
            cancelButtonTitle: cancel,
            otherButtonTitles: ok)
        
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
        
        var textField = alertView.textFieldAtIndex(0)
        textField!.placeholder = NSLocalizedString("Email", comment: "Email")
        textField!.keyboardType = UIKeyboardType.EmailAddress
        textField!.text = email!
        textField!.returnKeyType = UIReturnKeyType.Done
        
        alertView.show()
    }
    
    func _requestPasswordResetWithEmail(email: String) {
        PFUser.requestPasswordResetForEmailInBackground(email)
    }
    
    func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            let email = alertView.textFieldAtIndex(0)!.text
            self._requestPasswordResetWithEmail(email)
        }
    }
}

extension ViewController: LogInViewControllerDelegate {
    func logIn(controller: LogInViewController, failed error: NSError) {
        println("failed login \(error)")
    }
    
    func logIn(controller: LogInViewController, successful user: PFUser) {
        println("logIn \(user)")
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.app()
        self.registerDevice()
    }
    
    func logIn(controller: LogInViewController, facebook user: PFUser) {
        println("logIn \(user)")
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.app()
        self.registerDevice()
    }
    
    func logIn(controller: LogInViewController, skiped button: UIView) {
        println("skip")
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.app()
    }
    
    func logIn(controller: LogInViewController, sign signController: UIViewController) {
        self.presentViewController(signController, animated: true, completion: nil)
    }
    
    func logIn(controller: LogInViewController, forgot button: UIView, email: String?) {
        self.forgot(email)
    }
    
}

extension ViewController: SignUpViewControllerDelegate {
    func signUp(controller: SignUpViewController, failed error: NSError) {
        println("failed signUp \(error)")
    }
    
    func signUp(controller: SignUpViewController, successful user: PFUser) {
        println("signup \(user)")
        controller.dismissViewControllerAnimated(false, completion: { () -> Void in
            controller.presentedViewController?.dismissViewControllerAnimated(false, completion: { () -> Void in
            })
            
        })
    }
}
