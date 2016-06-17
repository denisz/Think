//
//  Location.swift
//  Think
//
//  Created by denis zaytcev on 8/28/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import CoreLocation
import Bolts
import FormatterKit

class Location: NSObject {
    static let sharedInstance = Location()
    var locationManager = CLLocationManager()
    var lastPlacemark: CLPlacemark? {
        didSet {
            if taskSource != nil {
                taskSource!.setResult(lastPlacemark!)
                taskSource = nil
            }
        }
    }
    var lastError: NSError? {
        didSet {
            if taskSource != nil {
                taskSource!.setError(lastError!)
                taskSource = nil
            }
        }
    }
    var taskSource: BFTaskCompletionSource?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationInfo() -> BFTask {
        if let taskSource = self.taskSource {
            return taskSource.task
        }
        
        self.taskSource = BFTaskCompletionSource()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        return self.taskSource!.task
    }
    
    class func formatter(placemark: CLPlacemark) -> String {
        let locality    = (placemark.locality != nil) ? placemark.locality : ""
        let postalCode  = (placemark.postalCode != nil) ? placemark.postalCode : ""
        let adminArea   = (placemark.administrativeArea != nil) ? placemark.administrativeArea : ""
        let country     = (placemark.country != nil) ? placemark.country : ""
        let street      = (placemark.thoroughfare != nil) ? placemark.thoroughfare : ""

        let formatter = TTTAddressFormatter()
        return formatter.stringFromAddressWithStreet(street, locality: locality, region: adminArea, postalCode: postalCode, country: country)
    }
}

extension Location: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {
            (placemarks, error) -> Void in
            if (error != nil) {
                self.lastError = error
                return
            }
            
            if placemarks!.count > 0 {
                if let pm = placemarks!.first {
                    self.lastPlacemark = pm
                }
            } else {
                self.lastError = error
            }
            
            self.locationManager.stopUpdatingLocation()
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.locationManager.stopUpdatingLocation()
        self.lastError = error
    }
}