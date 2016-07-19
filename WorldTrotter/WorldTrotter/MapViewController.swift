//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Dehelean Andrei on 7/13/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var mapView :MKMapView!

    override func loadView() {
        //create a map view
        mapView = MKMapView()
        
        //set it as the view for the view controller
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), forControlEvents: .ValueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        // add constraints programatically
        let topConstrain = segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 8)
        topConstrain.active = true
        
        let margins = view.layoutMarginsGuide
        let leadingConstrain = segmentedControl.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        leadingConstrain.active = true
        let trailingConstrain = segmentedControl.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        trailingConstrain.active = true
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func mapTypeChanged(segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Hybrid
        case 2:
            mapView.mapType = .Satellite
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

}
