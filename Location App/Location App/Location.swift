//
//  Location.swift
//  Location App
//
//  Created by Dehelean Andrei on 9/12/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import Foundation
import CoreData
import MapKit

@objc(Location)
class Location: NSManagedObject, MKAnnotation {
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoPath)
    }
    
    var hasPhoto: Bool {
        return photoID != nil
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    var title: String? {
        if locationDescription.isEmpty {
            return "(No Description)"
        } else {
            return locationDescription
        }
    }
    
    var subtitle: String? {
        return category
    }
    
    var photoPath: String {
        assert(photoID != nil, "No photo ID set")
        let filename = "Photo-\(photoID!.integerValue).jpg"
        return (applicationDocumentsDirectory as NSString).stringByAppendingPathComponent(filename)
    }
    
    class func nextPhotoID() -> Int {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let currentID = userDefault.integerForKey("Photo")
        userDefault.setInteger(currentID + 1, forKey: "Photo")
        userDefault.synchronize()
        return currentID + 1
    }
    
    func removePhotoFile() {
        if hasPhoto {
            let path = photoPath
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(path) {
                do {
                    try fileManager.removeItemAtPath(path)
                } catch {
                    print(error)
                }
            }
        }
    }

    
}
