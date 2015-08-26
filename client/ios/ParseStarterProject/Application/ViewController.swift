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
    var navigationControllerApp: BaseNavigationController?
    
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
        let mainController          = FeedViewController.CreateWith()
        let navigationController    = BaseNavigationController(rootViewController: mainController)
        let sideMenuController      = BaseSideMenuViewController(rootViewController: navigationController)
        
        setSideMenuController(sideMenuController)
        
        self.presentViewController(sideMenuController, animated:true, completion: nil)
        self.navigationControllerApp = navigationController
        self.bindEventMenu()
    }
    
    func bindEventMenu() {
        self.unbindEventMenu()
        
        for name in kSideMenu.allValues {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "handlerSequeNavigation:", name: name.rawValue as String, object: nil)
        }
    }
    
    func unbindEventMenu() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handlerSequeNavigation(notification: NSNotification) {
        if let menu = kSideMenu(rawValue: notification.name) {
            var controller: UIViewController?
            
            switch(menu) {
            case .Settings:
                controller = FactoryControllers.settings()
                break
            case .Notificaiton:
                controller = FactoryControllers.notifications()
                break
            case .Messages:
                controller = FactoryControllers.messages()
                break
            case .Feed:
                controller = FactoryControllers.feed()
                break
            case .Top:
                controller = FactoryControllers.top()
                break
            case .Profile:
                controller = FactoryControllers.myProfile()
                break
            case .Drafts:
                controller = FactoryControllers.drafts()
                break
            case .Bookmarks:
                controller = FactoryControllers.bookmarks()
                break
            default:
                controller = FactoryControllers.feed()
            }
            
            if controller != nil {
                self.navigationControllerApp?.replaceViewController(controller!, animated: true)
            }
        }
    }
    
    func unRegisterDevice() {
        Installation.unRegisterPushDevice()
    }
    
    func registerDevice() {
        Installation.eventsPush()
        Installation.registerPushDevice()
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
        //регистрация
        self.registerDevice()
        controller.dismissViewControllerAnimated(false, completion: { () -> Void in
            controller.presentedViewController?.dismissViewControllerAnimated(false, completion: { () -> Void in
            })
            
        })
    }
}

