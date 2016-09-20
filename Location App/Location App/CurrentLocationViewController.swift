//
//  FirstViewController.swift
//  Location App
//
//  Created by Dehelean Andrei on 9/9/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - Properties
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var updatingLocation = false
    var lastLocationError: NSError?
    
    let geoCoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: NSError?
    
    var timer: NSTimer?
    
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: - Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var longitudeTextLabel: UILabel!
    @IBOutlet weak var latitudeTextLabel: UILabel!
    
    // MARK: - Overridden functions
    override func viewDidLoad() {
        super.viewDidLoad()

        configureGetButton()
        updateLabels()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TagLocation" {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! LocationDetailsViewController
            controller.placemark = placemark
            controller.coordinates = (currentLocation?.coordinate)!
            controller.managedObjectContext = managedObjectContext
        }
    }


 
    // MARK: -  IBActions
    @IBAction func getLocation(sender: AnyObject) {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
            return 
        }
        
        if authStatus == .Denied || authStatus == .Restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        if updatingLocation {
            stopLocationManager()
        } else {
            currentLocation = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        updateLabels()
        configureGetButton()
    }
    
    // MARK: - Class methods
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            if let timer = timer {
                timer.invalidate()
            }
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
            
            timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false)
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }

    func didTimeOut() {
        if currentLocation == nil {
            stopLocationManager()
            
            lastLocationError = NSError(domain: "MyLocationErrorDomain", code: 1, userInfo: nil)
            
            updateLabels()
            configureGetButton()
        }
        
    }
    
    // MARK: - UI methods
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services in your settings", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateLabels() {
        if let location = currentLocation {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            messageLabel.text = nil
            tagButton.hidden = false
            
            if let placemark = placemark {
                addressLabel.text = stringFromPlacemark(placemark)
            } else if performingReverseGeocoding {
                addressLabel.text = "Searching for address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
                addressLabel.textColor = UIColor.redColor()
            } else {
                addressLabel.text = "Address not found"
            }
            
            longitudeTextLabel.hidden = false
            latitudeTextLabel.hidden = false
        } else {
            messageLabel.text = "Tap 'Get My Location' to start"
            latitudeLabel.text = nil
            longitudeLabel.text = nil
            tagButton.hidden = true
            addressLabel.text = nil
            
            //Handling errors
            let statusMessage: String
            if let error = lastLocationError {
                if error.domain == kCLErrorDomain && error.code == CLError.Denied.rawValue {
                    statusMessage = "Location Service Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled(){
                statusMessage = "Location Service Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to start"
            }
            
            messageLabel.text = statusMessage
            longitudeTextLabel.hidden = true
            latitudeTextLabel.hidden = true
        }
    }
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        var line1 = ""
        line1.addText(placemark.subThoroughfare, withSeparator: "")
        line1.addText(placemark.thoroughfare, withSeparator: " ")
        
        var line2 = ""
        line2.addText(placemark.locality, withSeparator: "")
        line2.addText(placemark.administrativeArea, withSeparator: " ")
        line2.addText(placemark.postalCode, withSeparator: " ")
        
        line1.addText(line2, withSeparator: "\n")
        
        return line1
    }
    
    func configureGetButton() {
        if updatingLocation {
            locationButton.setTitle("Stop", forState: .Normal)
        } else {
            locationButton.setTitle("Get My Location", forState: .Normal)
        }
    }


    
}

// MARK: -  CLLocationManagerDelegate methods
extension CurrentLocationViewController {

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        if error.code == CLError.LocationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        
        stopLocationManager()
        updateLabels()
        configureGetButton()
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        var distance = CLLocationDistance(DBL_MAX)
        if let location = currentLocation {
            distance = newLocation.distanceFromLocation(location)
        }
        if currentLocation == nil || currentLocation!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            currentLocation = newLocation
            updateLabels()
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                stopLocationManager()
                configureGetButton()
                
                if distance > 0 {
                    performingReverseGeocoding = false
                }
            }
            
            //Reverse geocoding
            if !performingReverseGeocoding {
                
                performingReverseGeocoding = true
                
                geoCoder.reverseGeocodeLocation(newLocation, completionHandler: {
                    placemarks, error in
                    
                    self.lastLocationError = error
                    if error == nil, let p = placemarks where !p.isEmpty {
                        self.placemark = p.last!
                    } else {
                        self.placemark = nil
                    }
                    
                    self.performingReverseGeocoding = false
                    self.updateLabels()
                })
            }
        } else if distance < 1.0 {
            let timeInterval = newLocation.timestamp.timeIntervalSinceDate(currentLocation!.timestamp)
            
            if timeInterval > 10 {
                stopLocationManager()
                updateLabels()
                configureGetButton()
            }
            
        }
    }
    
}
