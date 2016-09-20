//
//  MapViewController.swift
//  Location App
//
//  Created by Dehelean Andrei on 9/13/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    // MARK: - Properties
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextObjectsDidChangeNotification, object: managedObjectContext, queue: NSOperationQueue.mainQueue()) { (notification) in
                if self.isViewLoaded() {
                    self.updateLocations()
                }
            }
        }
    }
    var locations = [Location]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - IBActions
    @IBAction func showUser(sender: AnyObject) {
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    @IBAction func showLocations() {
        let region = regionForAnnotations(locations)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Overridden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLocations()
        
        if !locations.isEmpty {
            showLocations()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditLocation" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let editController = navigationController.topViewController as! LocationDetailsViewController
            editController.managedObjectContext = managedObjectContext
            let button = sender as! UIButton
            let location = locations[button.tag]
            editController.locationToEdit = location
        }
    }
    
    // MARK: - Methods
    private func updateLocations() {
        mapView.removeAnnotations(locations)
        
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: managedObjectContext)
        let request = NSFetchRequest()
        request.entity = entity
        
        if let objects = try? managedObjectContext.executeFetchRequest(request) as! [Location] {
            locations = objects
            mapView.addAnnotations(locations)
        }
    }
    
    func showLocationDetails(sender: UIButton) {
        performSegueWithIdentifier("EditLocation", sender: sender)
    }
    
    private func regionForAnnotations(annotations: [MKAnnotation]) -> MKCoordinateRegion {
        var region: MKCoordinateRegion
        
        switch annotations.count {
        case 0:
            region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
            
        case 1:
            let annotation = annotations.first
            region = MKCoordinateRegionMakeWithDistance((annotation?.coordinate)!, 1000, 1000)
            
        default:
            var topLeftCoordinate = CLLocationCoordinate2D(latitude: -90, longitude: 180)
            var bottomRightCoordinate = CLLocationCoordinate2D(latitude: 90, longitude: -180)
            
            for annotation in annotations {
                topLeftCoordinate.latitude = max(topLeftCoordinate.latitude, annotation.coordinate.latitude)
                topLeftCoordinate.longitude = min(topLeftCoordinate.longitude, annotation.coordinate.longitude)
                
                bottomRightCoordinate.latitude = min(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
                bottomRightCoordinate.longitude = max(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
            }
            let center = CLLocationCoordinate2D( latitude: topLeftCoordinate.latitude - (topLeftCoordinate.latitude - bottomRightCoordinate.latitude) / 2, longitude: topLeftCoordinate.longitude - (topLeftCoordinate.longitude - bottomRightCoordinate.longitude) / 2)
            let extraSpace = 1.1
            let span = MKCoordinateSpan(latitudeDelta: abs(topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * extraSpace, longitudeDelta: abs(topLeftCoordinate.longitude - bottomRightCoordinate.longitude) * extraSpace)
            region = MKCoordinateRegion(center: center, span: span)
            }
        
        return mapView.regionThatFits(region)
    }
        
}
    



extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        guard annotation is Location else { return nil }
        
        // 2
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as! MKPinAnnotationView!
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            // 3
            annotationView.enabled = true
            annotationView.canShowCallout = true
            annotationView.animatesDrop = false
            annotationView.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
            // 4
            let rightButton = UIButton(type: .DetailDisclosure)
            rightButton.addTarget(self, action: #selector(showLocationDetails), forControlEvents: .TouchUpInside)
            annotationView.rightCalloutAccessoryView = rightButton
            annotationView.tintColor = UIColor(white: 0.0, alpha: 0.5)
        } else {
            annotationView.annotation = annotation
        }
        // 5
        let button = annotationView.rightCalloutAccessoryView as! UIButton
        if let index = locations.indexOf(annotation as! Location) {
            button.tag = index
        }
        return annotationView
    }
}


extension MapViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}