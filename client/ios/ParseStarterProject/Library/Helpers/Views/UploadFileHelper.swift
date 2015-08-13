//
//  UploadFileHelper.swift
//  Think
//
//  Created by denis zaytcev on 8/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import JGProgressHUD
import Photos

enum UploadFileHelperScenario : UInt {
    case Avatar
    case Cover
}

class UploadFileHelper {
    class func selectAndUploadFile(controller: UIViewController, sourceView: UIView, scenario: UploadFileHelperScenario) {
        controller.presentImagePickerSheet(sourceView, sourceRect: sourceView.frame)
    }
    
    class func createHudProgress() -> JGProgressHUD {
        var HUD = JGProgressHUD(style: JGProgressHUDStyle.Dark)
        let window = UIApplication.sharedApplication().keyWindow!
        
        HUD.showInView(window)//может сделать показ на window
        self.progressHudProgress(HUD, progress: 0)
        HUD.indicatorView = JGProgressHUDPieIndicatorView(HUDStyle: JGProgressHUDStyle.Dark)
        HUD.textLabel.text = "Загрузка...".localized
        HUD.detailTextLabel.text = nil
        HUD.layoutChangeAnimationDuration = 0.0
        
        return HUD
    }
    
    class func progressHudProgress(HUD: JGProgressHUD, progress: Float) {
        HUD.setProgress(progress, animated: false)
    }
    
    class func successHudProgress(HUD: JGProgressHUD) {
        HUD.textLabel.text = "Загружено".localized
        HUD.detailTextLabel.text = nil
        HUD.layoutChangeAnimationDuration = 0.3
        HUD.indicatorView = JGProgressHUDSuccessIndicatorView()
        
        var delta: Int64 = 1 * Int64(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, delta)
        
        dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
            HUD.dismiss();
        })
    }
    
    class func failedHudProgress(HUD: JGProgressHUD) {
        HUD.textLabel.text = "Ошибка".localized
        HUD.detailTextLabel.text = nil
        HUD.layoutChangeAnimationDuration = 0.3
        HUD.indicatorView = JGProgressHUDErrorIndicatorView()
        
        var delta: Int64 = 1 * Int64(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, delta)
        
        dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
            HUD.dismiss();
        })
    }
}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentImagePickerSheet(sourceView: UIView, sourceRect: CGRect) {
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        if authorization == .NotDetermined {
            PHPhotoLibrary.requestAuthorization() { status in
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentImagePickerSheet(sourceView, sourceRect: sourceRect)
                }
            }
            
            return
        }
        
        if authorization == .Authorized {
            let presentImagePickerController: UIImagePickerControllerSourceType -> () = { source in
                let controller = UIImagePickerController()
                controller.delegate = self
                var sourceType = source
                
                if (!UIImagePickerController.isSourceTypeAvailable(sourceType)) {
                    sourceType = .PhotoLibrary
                    println("Fallback to camera roll as a source since the simulator doesn't support taking pictures")
                }
                
                controller.sourceType = sourceType
                self.presentViewController(controller, animated: true, completion: nil)
            }
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let cameraAction = UIAlertAction(title: "Сделать фото".localized, style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) in presentImagePickerController(.Camera) })
            
            let libraryAction = UIAlertAction(title: "Открыть библиотеку".localized, style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) in presentImagePickerController(.PhotoLibrary) })
            
            let cancelAction = UIAlertAction(title: "Закрыть".localized, style: UIAlertActionStyle.Cancel, handler: nil)
            
            actionSheet.addAction(cameraAction)
            actionSheet.addAction(libraryAction)
            actionSheet.addAction(cancelAction)
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                actionSheet.popoverPresentationController!.sourceRect = sourceRect
                actionSheet.popoverPresentationController!.sourceView = sourceView
            }
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
        else {
            let alertView = UIAlertView(title: NSLocalizedString("An error occurred", comment: "An error occurred"), message: NSLocalizedString("ImagePickerSheet needs access to the camera roll", comment: "ImagePickerSheet needs access to the camera roll"), delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
            alertView.show()
        }
    }
}